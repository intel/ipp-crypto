Intel® Integrated Performance Primitives Cryptography (Intel® IPP Cryptography) Contribution Rules
===============================================================

## How to Contribute

We welcome community contributions to Intel® IPP Cryptography!

If you have an idea how to improve the product:

 - Let us know via [GitHub* Issues](https://github.com/intel/ipp-crypto/issues).
 - Send your proposal directly via [pull request](https://github.com/intel/ipp-crypto/pulls).



## Intel® IPP Cryptography repository scheme

Intel® IPP Cryptography supports two repositories that are named as "Public Repository" and "Inner Repository". Privately hosted "Inner Repository" is required for extensive internal testing and experimental features development.

Existing automation guarantees regular synchronization of repositories.

<pre>
  +-------------+                     +------------+
  | Public Repo |        regular      | Inner Repo |
  | ----------- |    synchronization  |  --------  |       +----------+
  |    rev.1    | <------------------ |    rev.1   |       | internal |
  |    rev.2    |   bunch of changes  |    rev.2   |-----> | testing  |
  |    rev.3    |                     |    rev.3   |       +----------+
  +-------------+                     +------------+
</pre>

## Contribution Flow

- Contributor creates fork from develop, commits the changes into the created branch, opens a PR and requests a review.
- Contributor applies feedback provided by Intel® IPP Cryptography repository maintainer in opened PR.
- Intel® IPP Cryptography repository maintainer must ensure that the code is safe for internal execution, get code into inner repository and run private testing.
- Intel® IPP Cryptography repository maintainer merges the changes "as is" from inner repository, when private testing is passed.
> **Note**
> Original PR is closed because merging PRs on the external GitHub repo isn't supported.

- Contributions will be available in the "Public repository", once the nearest cycle of synchronization from "Inner Repository" to "Public Repository" happens.

<pre>

  +-----------------+
  |   Public Repo   |
  |   -----------   |
  |   PR is open    |
  |       |         |
  |       |         |
  |       |         |                      +--------------------+
  |  Code Review    |                      |     Inner Repo     |
  |   has passed    |                      |      ---------     |
  |       |         |  PR is cherry-picked |    Heavy private   |
  |       |---------|----------------------|->     testing      |
  |       |         |   to "Inner Repo"    |          |         |
  |  PR is closed   |                      |          |         |
  +-----------------+                      |  Cherry-picked PR  |
                                           |     is merged      |
                                           |  to "Inner Repo"   |
                                           +--------------------+

</pre>

## Pull Request Checklist
Before sending your pull requests, ensure that:
 - Intel® IPP Cryptography builds successfully with proposed changes using one of the compilers listed in [Build](./BUILD.md). Please specify which exact compiler was used.
 - Relevant documentation are added (for example CHANDELOG.md, README.md etc)
 - For new features make sure that
    - All new files are covered by copyrights.
    - All new internal functions are documented in comments.
    - Relevant examples are added(if required).

