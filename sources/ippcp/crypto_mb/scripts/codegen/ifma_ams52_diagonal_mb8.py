################################################################################
# Copyright 2019-2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

## 
##  Purpose: MB RSA.
## 
##  Contents: codegenerator stuff. modular squaring
##


import sys
import math

# Global variables
typedef = ""

functions = "#if defined(__GNUC__) && !defined(__INTEL_COMPILER)\n"\
"#define ASM(a) __asm__(a);\n"\
"#else\n"\
"#define ASM(a)\n"\
"#endif"

code = ""
function_name = sys.argv[2]
parameters = "int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8"

# Algorithm parameters
simd=True
n=20
if len(sys.argv) > 2:
    n = int(sys.argv[3])

if n > 20: # and ( (n % 10) == 0):
    tiled_reduction = True

    # Tiling parameters
    # FIXME: Use tiling parameters to generate tiled code. It is hardcoded to 10 currently
    Tv = 10
    Th = 10
    # Number of vertical tiles
    n_tiled = Tv * int(math.ceil((n + Tv - 1) // Tv))
    skip_last_red = n_tiled - n

    res = list(map(lambda x: "res[%d]" % x, range(0, 2*n_tiled)))
    code += "  __ALIGN64 __m512i res[{}];\n".format(2*n_tiled)
else:
    n_tiled = n
    tiled_reduction = False
    res = list(map(lambda x: "res%d" % x, range(0, 2*n_tiled)))
    code += "  __m512i %s;\n" % (", ".join(res))

iters=1
if len(sys.argv) > 3:
    iters = int(sys.argv[4])


# Define res values and set to 0
# Define vars
if tiled_reduction:
    code += "  __ALIGN64 __m512i u[%d];\n" % n_tiled
    code += "  __m512i carry;\n"
code += "  __m512i k;\n"
code += "  __m512i *a = (__m512i *)inpA_mb8;\n";
code += "  __m512i *m = (__m512i *)inpM_mb8;\n";
code += "  __m512i *r = (__m512i *)out_mb8;\n";
if iters > 1:
    code += "  int iter;\n"
    code += "  const int iters = {iters};\n".format(iters=iters)
code += "\n"
code += "  k = _mm512_loadu_si512((__m512i*)k0_mb8);\n"

# Begin loop over the number of squaring operations
if iters > 1:
    code += " for(iter=0; iter<iters; ++iter)\n {\n"

if tiled_reduction:
    code += "  // Cleanup square result intermidiate storage\n"\
            "  for(int i=0; i<{n}; ++i) res[i] = get_zero64();\n\n".format(n=len(res))
else:
    code += "  %s = get_zero64();\n" % (" = ".join(res))

wcode = []

code += "  // Calculate full square\n"

sqr_tile_size = 12
class OperationType:
    SUM     = 0
    DOUBLE  = 1
    ADD_SQR = 2

# Sqr operation weight function
#   Order operation to increase data reuse chances
def Weigth(bucket, operation, weight):
    return (bucket,operation,weight)

# Squaring with reduction
for c in range(0,2*(n-1)+1):
    ib = max(0,c - n + 1)
    ie = c // 2
    sum_lo = res[c]
    sum_hi = res[c+1]

    for i in range(ib, ie + 1):
        if i != c-i:
            # Accumulate sum
            w = Weigth(int(c/sqr_tile_size), OperationType.SUM, (c-i))
            wcode.append(("  {slo} = fma52lo({slo}, a[{i}], a[{j}]);\t// Sum({c})\n"\
                          "  {shi} = fma52hi({shi}, a[{i}], a[{j}]);\t// Sum({c})\n".format(c=c, slo=sum_lo, shi=sum_hi, i=i, j=c-i, w=w), w))

# Double sum
for c in range(0,2*(n-1)+1):
    ib = max(0,c - n + 1)
    ie = c // 2
    sum_lo = res[c]
    sum_hi = res[c+1]
    w = Weigth(int(c/sqr_tile_size), OperationType.DOUBLE, 0)
    wcode.append(("    {slo} = add64({slo}, {slo});\t// Double({c})\n".format(c=c, slo=sum_lo, shi=sum_hi), w))

# Adding Square if needed
for c in range(0,2*(n-1)+1):
    ib = max(0,c - n + 1)
    ie = c // 2
    sum_lo = res[c]
    sum_hi = res[c+1]
    for i in range(ib, ie + 1):
        if i == c-i:
            w = Weigth(int(c/sqr_tile_size), OperationType.ADD_SQR, 0)
            wcode.append(("      {slo} = fma52lo({slo}, a[{i}], a[{i}]);\t// Add sqr({c})\n"\
                          "      {shi} = fma52hi({shi}, a[{i}], a[{i}]);\t// Add sqr({c})\n".format(c=c, slo=sum_lo, shi=sum_hi, i=i), w))

# Sort squaring code based on weight assigned
wcode.sort(key=lambda tup: tup[1])
for line in wcode:
    code += line[0]


if tiled_reduction:
    body_0 = ""
    body   = ""
    carry  = ""
    for i in range(0,Tv):

        if i == 0:
            body_0 += "           if ((it+{i}) > 0) res[it + {idx_hi}] = add64(res[it + {idx_hi}], srli64(res[it + {idx_lo}], DIGIT_SIZE));\n"\
                .format(i=i, idx_lo=i-1, idx_hi=i)
        else:
            body_0 += "           res[it + {idx_hi}] = add64(res[it + {idx_hi}], srli64(res[it + {idx_lo}], DIGIT_SIZE));\n"\
                .format(i=i, idx_lo=i-1, idx_hi=i)
        if (i > (Tv - skip_last_red - 1) ):
            body_0 += "           u  [it + {i}] = (it + {i} < {n}) ? mul52lo(res[it + {idx}], k) : _mm512_setzero_si512();\n"\
                .format(i=i, idx=i, n=n)
        else:
            body_0 += "           u  [it + {i}] = mul52lo(res[it + {idx}], k);\n"\
                .format(i=i, idx=i)

        # TODO: Pipeline carry propagation
        # carry  += "        res[10+jt+{idx}] = add64(res[10+jt+{idx}], carry);\n"\
        #           "        carry = srli64(res[10+jt+{idx}], DIGIT_SIZE);\n"\
        #           .format(idx=i)

        for j in range(0,Th):
            body_0 += "      res[it+jt+{idx_lo}] = fma52lo(res[it+jt+{idx_lo}], u[it+{i}], m[jt+{m_idx}]);\n"\
                      "      res[it+jt+{idx_hi}] = fma52hi(res[it+jt+{idx_hi}], u[it+{i}], m[jt+{m_idx}]);\n"\
                      .format(idx_lo=i+j, idx_hi=i+j+1, i=i, m_idx=j)
            body   += "      res[it+jt+{idx_lo}] = fma52lo(res[it+jt+{idx_lo}], u[it+{i}], m[jt+{m_idx}]);\n"\
                      "      res[it+jt+{idx_hi}] = fma52hi(res[it+jt+{idx_hi}], u[it+{i}], m[jt+{m_idx}]);\n"\
                      .format(idx_lo=i+j, idx_hi=i+j+1, i=i, m_idx=j)

    code += "\n  // Montgomery Reduction\n"\
            "  carry = _mm512_setzero_si512();\n"\
            "  for (int it = 0; it < {n}; it += 10) {{ // Reduction step\n"\
            "    int jt = 0;\n"\
            "{body_0}\n"\
            "    for (jt = 10; jt < {n}; jt += 10) {{ // Poly tile\n"\
            "{body}\n"\
            "    }}\n"\
            "  }}\n".format(body=body, body_0=body_0, carry=carry, n=n_tiled)

else:

    code += "\n// Generate u_i\n"
    code += "  __m512i u{i} = mul52lo({res},k);\n".format(i=0, res=res[0])
    for i in range(0, n):
        # Nasty performance hack - restart DSB
        if i % 2 == 0:
            code += "ASM(\"jmp l{i}\\nl{i}:\\n\");\n".format(i=i)

        code += "\n    // Create u{i}\n".format(i=i)
        for mi in range(0, n):
            if mi%2==0:
                code += "    _mm512_madd52lo_epu64_({res_lo}, {res_lo}, u{i}, m, 64*{mi});\n"\
                        "    _mm512_madd52hi_epu64_({res_hi}, {res_hi}, u{i}, m, 64*{mi});\n"\
                        .format(res_lo=res[i+mi], res_hi=res[i+mi+1], i=i, mi=mi)
            else:
                code += "    {res_lo} = fma52lo({res_lo}, u{i}, m[{mi}]);\n"\
                        "    {res_hi} = fma52hi({res_hi}, u{i}, m[{mi}]);\n"\
                        .format(res_lo=res[i+mi], res_hi=res[i+mi+1], i=i, mi=mi)

            if (mi == 1): ## Ready to calculate next u
                # Carry propogation
                code += "    {res_hi} = add64({res_hi}, srli64({res_lo}, DIGIT_SIZE));\n"\
                        .format(res_lo=res[i], res_hi=res[i+1])
                if i < n-1:
                    code += "    __m512i u{i} = mul52lo({res},k);\n".format(i=i+1, res=res[i+mi])

code += "\n  // Normalization\n"
for i in range(n,2*n):
    # No need to do first reduction step for non tiled implementation
    if (not tiled_reduction and i > n) or (tiled_reduction and (i>n or n==n_tiled)):
    # if i > n:
        code += "  {res} = add64({res}, srli64({res_p}, DIGIT_SIZE));\n".format(idx=i-n, res=res[i], res_p=res[i-1])

    # Upper bits cleanup
    if iters == 1: # Single square with full reduction and bit cleanup
        code += "  r[{idx}] = and64_const({res}, DIGIT_MASK);\n".format(idx=i-n, res=res[i], res_p=res[i-1])
    else:          # Multi-square operation. We do not cleanup upper bits in result
        code += "  r[{idx}] = {res};\n".format(idx=i-n, res=res[i], res_p=res[i-1])

# end loop
if iters > 1:
    code += " a = (__m512i *)out_mb8;\n }\n"

# DEBUG: Dump results for validation
if False:
    for i in range(0, n):
        code += "{ uint64_t *v = (uint64_t *)&u[%d];\n" % i
        for k in range(0, 8):
            code += "printf(\" %%llx\", v[%d]);\n" % (k)
        code += "printf(\"\\n\"); }\n"

    for i in range(0, 2*n):
        code += "printf(\"  %d: \");\n" % i
        for k in range(0, 8):
            code += "printf(\" %%llx\", ((uint64_t*)&%s)[%d]);\n" % (res[i], k)
        code += "printf(\"\\n\");"
    code += "exit(-1);\n"

# load template and generate source code
f = open(sys.argv[1], 'r')
template = f.read()
f.close()

template = template.replace("{typedef}", typedef)
template = template.replace("{functions}", functions)
template = template.replace("{function_name}", function_name)
template = template.replace("{parameters}", parameters)
template = template.replace("{code}", code)

print(template)
