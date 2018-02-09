public protocol HttpApp {
    func respond(_ request: _HTTPRequest) -> _HTTPResponse 
}

public struct _HTTPUtils {
    public static let CRLF = "\r\n"
    public static let VERSION = "HTTP/1.1"
    public static let SPACE = " "
    public static let CRLF2 = CRLF + CRLF
    public static let EMPTY = ""
}

public struct _HTTPRequest {
    public enum Method : String {
        case GET, POST, PUT
    }
    let method: Method
    let uri: String 
    let body: String
    let headers: [String]

    public init(request: String) {
        let lines = request.components(separatedBy: _HTTPUtils.CRLF2)[0].components(separatedBy: _HTTPUtils.CRLF)
        headers = Array(lines[0...lines.count-2])
        method = Method(rawValue: headers[0].components(separatedBy: " ")[0])!
        uri = headers[0].components(separatedBy: " ")[1]
        body = lines.last!
    }

    public func getCommaSeparatedHeaders() -> String {
        var allHeaders = ""
        for header in headers {
            allHeaders += header + ","
        }
        return allHeaders
    }

}

public struct _HTTPResponse {
    public enum Response : Int {
        case OK = 200
        case REDIRECT = 302
    }
    private let responseCode: Response
    let headers: String
    let body: String

    public init(response: Response, headers: String = _HTTPUtils.EMPTY, body: String) {
        self.responseCode = response
        self.headers = headers
        self.body = body
    }
   
    public var header: String {
        let statusLine = _HTTPUtils.VERSION + _HTTPUtils.SPACE + "\(responseCode.rawValue)" + _HTTPUtils.SPACE + "\(responseCode)"
        return statusLine + (headers != _HTTPUtils.EMPTY ? _HTTPUtils.CRLF + headers : _HTTPUtils.EMPTY) + _HTTPUtils.CRLF2
    }
}

public struct HTTP : ApplicationProtocol {
    let app: HttpApp

    public init(_ app: HttpApp) {
        self.app = app
    }

    public func process(_ request: String) -> [String] {
        let request = _HTTPRequest(request: request)
        let response = app.respond(request) 
        print(response.body)
        return [response.headers, response.body]
    }
}

struct TestApp : HttpApp { 
    let capitals: [String:String] = [
        "Nepal":"Kathmandu",
        "Peru":"Lima",
        "Italy":"Rome1",
        "USA":"Washington, D.C.",
        "UnitedStates": "USA",
        "country.txt": "A country is a region that is identified as a distinct national entity in political geography"
    ]

    func respond(_ request: _HTTPRequest) -> _HTTPResponse {
        guard request.method == .GET || request.method == .POST || request.method == .PUT else { fatalError("Unsupported method!") }
        let uri = request.uri

        if uri == "/country.txt" {
            let text = capitals[String(uri.dropFirst())]!
            return _HTTPResponse(response: .OK, headers: "Content-Length: \(text.data(using: .utf8)!.count)", body: text)
        }

        return _HTTPResponse(response: .OK, body: capitals[String(uri.dropFirst())]!)
    } 
}
