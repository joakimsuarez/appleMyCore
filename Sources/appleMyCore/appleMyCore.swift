import Foundation
import SWXMLHash

/// Wrapper around XMLHash.parse to avoid symbol shadowing issues on Windows.
/// On some platforms, especially Windows, the module name 'SWXMLHash' can shadow global symbols,
/// making 'SWXMLHash.parse(...)' inaccessible in certain files.
/// By exposing this wrapper from appleMyCore, we ensure consistent access to XML parsing
/// across all modules, regardless of platform-specific compiler behavior.
public func parseXML(_ data: Data) -> XMLIndexer {
    return XMLHash.parse(data)
}

#if os(macOS) || os(iOS) || os(watchOS)
public typealias HealthEngineImpl = HealthEngineApple
#elseif os(Windows)
public typealias HealthEngineImpl = HealthEngineWindows
#endif
