# Scizzors

![Scizzors CI/CD Status](https://img.shields.io/badge/status-in%20development-orange.svg) 
![Language](https://img.shields.io/badge/language-Zig-blueviolet.svg)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A high-performance network packet dissection library built from scratch in Zig. **Scizzors** provides a Domain-Specific Language (DSL) that allows developers to define and parse network protocols with unparalleled speed, memory efficiency, and cross-language compatibility.

## ✂️ Core Philosophies

"Scizzors" is engineered with a clear set of principles to be the fastest and most memory-efficient solution for packet dissection.

### 1. Speed is Non-Negotiable 🚀
Scizzors is written in Zig to provide a level of low-level control and performance that is unmatched. We aim to squeeze every last drop of performance out of the system, leveraging Zig's manual memory management and powerful compile-time features to eliminate runtime overhead.

### 2. Simplicity & Compatibility ✨
The heart of Scizzors is its elegant DSL, designed to make defining and dissecting packets as simple as possible. Built with Zig's seamless C interoperability, Scizzors can be compiled as a C-compatible library, making it accessible from almost any modern programming language (e.g., Python, Rust, C++, Ruby, etc.) via its FFI.

### 3. Extreme Memory Efficiency 🧠
Scizzors gives developers explicit control over memory. This allows for the use of specialized allocators and carefully packed data structures, ensuring the library's memory footprint is as minimal as possible.

### 4. Reasonable Safety ✅
While prioritizing performance, Scizzors adopts a pragmatic approach to safety. We use Zig's explicit error handling, robust `defer` statements, and thorough compiler-enabled sanitizers during development to ensure the resulting library is reliable and bug-free.

## 📦 Features (Coming Soon)

- [ ] A declarative DSL for defining network protocols in a human-readable format.
- [ ] Compile-time parser generation for zero-cost runtime dissection.
- [ ] Support for common protocols out of the box (e.g., Ethernet, IPv4, IPv6, TCP, UDP).
- [ ] A C-compatible API for use with any language that supports C FFI.
- [ ] Minimal dependencies and a small, highly efficient footprint.

## ⚙️ Getting Started

This section will be populated once the project has an initial working prototype. It will include instructions on how to clone the repository, build the library with the Zig toolchain, and integrate it into your project.

### Prerequisites
- [Zig](https://ziglang.org/) (latest master or a stable release)

## 🤝 Contributing

Contributions are welcome! Please read the `CONTRIBUTING.md` file (to be created) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
