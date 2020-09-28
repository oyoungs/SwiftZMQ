import CZeroMQ

typealias ZMQContext = UnsafeMutableRawPointer
typealias ZMQSocket = UnsafeMutableRawPointer


public class Version {
    public static let major: Int = Int(ZMQ_VERSION_MAJOR)
    public static let minor: Int = Int(ZMQ_VERSION_MINOR)
    public static let patch: Int = Int(ZMQ_VERSION_PATCH)
}
/*  Socket types. */
//public var ZMQ_PUB: Int32 { get }
//public var ZMQ_SUB: Int32 { get }
//public var ZMQ_REQ: Int32 { get }
//public var ZMQ_REP: Int32 { get }
//public var ZMQ_DEALER: Int32 { get }
//public var ZMQ_ROUTER: Int32 { get }
//public var ZMQ_PULL: Int32 { get }
//public var ZMQ_PUSH: Int32 { get }
//public var ZMQ_XPUB: Int32 { get }
//public var ZMQ_XSUB: Int32 { get }
//public var ZMQ_STREAM: Int32 { get }

public enum SocketType: Int32 {
    case pair
    case publish
    case subscribe
    case request
    case response
    case dealer
    case router
    case pull
    case push
    case xpublish
    case xsubscribe
    case stream
}

public enum ContextOptionType: Int32 {
    case ioThreads = 1
    case maximumSockets
    case socketLimit
    case threadPriority
    case threadSchedPolicy
    case maximumMsgSize
    case msgTSize
    case threadAffinityCpuAdd
    case threadAffinityCpuRemove
    case threadNamePrefix
}

public typealias ContextOption = (type: ContextOptionType, value: Int)


public class Socket {
    
    let socket: ZMQSocket
    
    init(sock: ZMQSocket) {
        socket = sock
    }
    
    deinit {
        zmq_close(socket)
    }
    
    
    public func bind(address: String) throws {
        guard zmq_bind(socket, address) == 0 else {
            throw ZMQError.fromErrno
        }
    }
    
    public func connect(address: String) throws {
        guard zmq_connect(socket, address) == 0 else {
            throw ZMQError.fromErrno
        }
    }
    
    public func disconnect(address: String) throws {
        guard zmq_disconnect(socket, address) == 0 else {
            throw ZMQError.fromErrno
        }
    }
}


public enum ZMQError: Int32 {
    
    case none

    public static var fromErrno: ZMQError {
        return ZMQError(rawValue: zmq_errno())!
    }
    
    public var description: String {
        return String(cString: zmq_strerror(rawValue)!)
    }
}

extension ZMQError: Error {}

public class Context {
    
    let context: ZMQContext
    
    public static var shared = Context()
    
    init() {
        context = zmq_ctx_new();
    }
    
    func terminate() throws {
        guard zmq_ctx_term(context) == 0 else {
            throw ZMQError.fromErrno
        }
    }
    
    func shutdown() throws {
        guard zmq_ctx_shutdown(context) == 0 else {
            throw ZMQError.fromErrno
        }
    }
    
    func option(type: ContextOptionType) -> ContextOption {
        return ContextOption(type: type, value: Int(zmq_ctx_get(context, type.rawValue)))
    }
    
    func setOption(option: ContextOption) throws {
        guard zmq_ctx_set(context, option.type.rawValue, Int32(option.value)) == 0 else {
            throw ZMQError.fromErrno
        }
    }
    
    
    func socket(type: SocketType) -> Socket {
        return Socket(sock: zmq_socket(context, type.rawValue))
    }
    
    public var pair: Socket {
        return socket(type: .pair)
    }
    
    public func newPublisher() -> Socket {
        return socket(type: .publish)
    }
    
    public func  newSubscriber() -> Socket {
        return socket(type: .subscribe)
    }
    
    public func  newRequest() -> Socket {
        return socket(type: .request)
    }
    
    public func newResponse() -> Socket {
        return socket(type: .response)
    }
    
    public func newDealer() -> Socket {
        return socket(type: .response)
    }
    
    public func newRouter() -> Socket {
        return socket(type: .router)
    }
    
    public func newPuller() -> Socket {
        return socket(type: .pull)
    }
    
    public func newPusher() -> Socket {
        return socket(type: .push)
    }
    
    public func newXPublisher() -> Socket {
        return socket(type: .xpublish)
    }
    
    public func newXSubscriber() -> Socket {
        return socket(type: .xsubscribe)
    }
    
    public func newStream() -> Socket {
        return socket(type: .stream)
    }
    
    deinit {
        zmq_ctx_destroy(context)
    }
    
}



