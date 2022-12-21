# Networking

This package helps your app talk to any remote HTTP server.  You can achieve this with very little client code, thanks to the power of Swift protocols and the Combine framework.

Your client should define types that conform to `Requestable`.  These represent particular invocations of HTTP endpoints.  They specify HTTP request values (URL, headers, body, query, etc.) through computed properties, and they should accept any variable data as constructor arguments.  Each adopter of `Requestable` must also specify associated types called `Input` and `Response`.  One or both of those may be `Void`.

Instantiate one of your `Requestable` adopters.  Then, provide the instance to `RealNetworkProvider.sendRequest(for:)` to obtain a Combine `Publisher`.  This publisher contacts the remote server and yields an instance of your adopter's `Response` type if successful or a `NetworkError` if unsuccessful.

Instead of using `RealNetworkProvider`, you can create a custom adopter of the `Networking` protocol to implement a mock server for frontend testing.

To bind your UI to the invocation of the endpoint, create an instance of `ServiceForEndpoint`.  `ServiceForEndpoint` is a generic class that calls an endpoint (as specified by an injected `Requestable` type) and exposes the status of the request through an `@Published` property that wraps the request's outcome in a `LoadingState` enum.

`ServiceForEndpoint` has two type parameters: a `Requestable` (the endpoint to be invoked) and an output (the value to be delivered to the UI, which may or may not be the same as the endpoint's output—if they differ, you must specify a mapping strategy when you create a `ServiceForEndpoint` instance).
