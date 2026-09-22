# ROCm contribution provenance

This integration preserves the original commit ancestry of both contributions.

| Contributor | Original contribution | Retained work / integration |
|---|---|---|
| dockylf | [PR #10](https://github.com/kvmem/kvmem-llama.cpp/pull/10), head `b183c3a` | Windows HIP runtime aliases, Windows host/CLI compatibility, HIP build foundation. The adapter uses the standalone runtime shim from this work. |
| FangJiangyi | [PR #33](https://github.com/kvmem/kvmem-llama.cpp/pull/33), head `a7460f3` | Linux HIP and replay integration, factory-header correction, ROCm measurements and tools, CPU vision thread propagation. Native Linux HIP is enabled at the top level; the shared source is retained. |
| Zeshen | Integrated branch | Windows/Linux build unification, device architecture detection including WSL, native wave32/wave64 fold handling, strengthened replay regression, Windows loading-mode validation, IQ3 launchers, packaging and usage documentation. |

Overlapping runtime aliases and build blocks have one implementation in the final tree.
The original commits remain accessible through merge ancestry even where lines were subsequently changed.
Line counts are not percentages of ownership.

The CUDA kernel launch remains 32 lanes. HIP selects the device wave width for GDN folding.
The standalone shim avoids requiring private ggml CUDA vendor headers from adapter code.
HIP staging is an object target: native HIP on Linux, AMD Clang CXX/HIP mode on Windows.
CUDA toolkit discovery is restricted to the CUDA backend.

For final integration, use a normal **merge commit** to retain this history.
A squash merge discards the individual commit ancestry; attribution would then need to be explicitly
carried into the final squash commit. GitHub associates author email addresses with accounts and
updates contributor graphs after commits reach the default branch; this process is not instantaneous.

Both original author identities are unchanged:

- dockylf: `dzdg_ddd@126.com`
- FangJiangyi: `2301111925@stu.pku.edu.cn`

AI assisted the integration and validation preparation. The submitter reviews the final changes before publication.
