resource "kubernetes_manifest" "internal_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      name = "external-http"
    }

    spec = {
      gatewayClassName = "gke-l7-rilb"
      listeners = [{
        name = "http"
        protocol = "HTTP"
        port = 80
      },
      {
        name = "https"
        protocol = "HTTPS"
        port = 443
        tls = {
            mode = "Terminate"
            options = {
                networking.gke.io/pre-shared-certs = "gateway-ssl-cert"
            }
        }
      }]
    }
  }
}

resource "kubernetes_manifest" "httproute" {
    manifest = {
        apiVersion = "gateway.networking.k8s.io/v1beta1"
        kind = "HTTPRoute"

        metadata = {
            name =  "gateway-routes"
        }

        spec = {
            parentRef = [{
                kind = "Gateway"
                name = "external-http"
            }]
            hostnames = [
                "gateway.searce-aben.com"
            ]
            rules = [{
                path = [{
                    type = "PathPrefix"
                    value = "/number"
                }]
                filters = [
                    {
                        type = "RequestRedirect"
                        requestRedirect = {
                            path = {
                                type = "ReplaceFullPath"
                                ReplaceFullPath = "/numero"
                            }
                        }
                        statusCode = 302
                    }
                ]
            }]
        }
    }
}

resource "kubernetes_manifest" "httproute" {
    manifest = {
        apiVersion = "gateway.networking.k8s.io/v1beta1"
        kind = "HTTPRoute"

        metadata = {
            name =  "gateway-routes"
        }

        spec = {
            parentRef = [{
                kind = "Gateway"
                name = "external-http"
            }]
            hostnames = [
                "gateway.searce-aben.com"
            ]
            rules = [
                {
                    backendRefs = {
                        name = "un"
                        port = "8080"
                    }
                }
            ]
        }
    }
}