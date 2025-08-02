Scizzors
A high-performance network packet dissection library written in Zig. Scizzors provides a Domain-Specific Language (DSL) that allows developers to define and parse network protocols with maximum speed, efficiency, and cross-language compatibility.

✂️ Why Scizzors?
"Scizzors" is a domain-specific dissection library designed to be the fastest and most memory-efficient solution available. It is built on a few core philosophies:

Speed is Non-Negotiable: Scizzors is written in Zig to provide a level of low-level control and performance that is unmatched. We aim to squeeze every last drop of performance out of the system, leveraging Zig's manual memory management and compile-time features to eliminate runtime overhead.

Simplicity & Usability: The core of Scizzors is its elegant DSL, designed to make defining and dissecting packets as simple as possible. The library will provide a clean, intuitive API that handles the low-level complexity for you.

Universal Compatibility: Built with Zig's seamless C interoperability, Scizzors can be compiled as a C-compatible library. This means it can be used with a simple Foreign Function Interface (FFI) from almost any modern programming language, including Python, Rust, C++, Ruby, and more.

Memory Efficiency: By giving the developer explicit control over memory, Scizzors is engineered to be extremely memory-efficient, using custom allocators and carefully packed data structures to reduce memory footprint to the absolute minimum.

✨ Features (Coming Soon)
A declarative DSL for defining network protocols in a human-readable format.

Compile-time parser generation for zero-cost runtime dissection.

Support for common protocols out of the box (e.g., Ethernet, IPv4, IPv6, TCP, UDP).

A C-compatible API for use with any language that supports C FFI.

Minimal dependencies and a small, highly efficient footprint.

🚀 Getting Started
This section will be populated once the project has an initial working prototype. It will include instructions on how to clone the repository, build the library with the Zig toolchain, and integrate it into your project.

Prerequisites
Zig (latest master or a stable release)

