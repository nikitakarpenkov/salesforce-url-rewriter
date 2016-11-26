global class SiteUrlRewriter implements Site.UrlRewriter {
    
    
    List<Route> routeList = new List<Route> {
        new Route('/account', Page.SiteAccountsList),
        new Route('/account/:accountId', Page.SiteAccountView),
        new Route('/account/:accountId/edit', Page.SiteAccountEdit),
        new Route('/account/:accountId/contacts', Page.SiteAccountContactsList)
    };    
                
                
                
    @testVisible
    private static List<String> splitUrl(String url) {
        while(url.indexOf('//') > -1) {
            url = url.replaceAll('//', '/');
        }
        url = url.removeStart('/').removeEnd('/');
        return String.isBlank(url) ? new List<String>() : url.split('/');
    }
    
    
    private class RoutePart {
        public String name;
        public Boolean isParameter;
        public RoutePart(String routePartString) {
            isParameter = routePartString.startsWith(':');
            name = isParameter ? routePartString.substringAfter(':') : routePartString;
        }
    }
    
    @testVisible
    private class Route {
        
        public PageReference redirectTo { get; set; }
        public String path { get; set; }
        List<RoutePart> routePartList;
        Map<String, String> parameterMap;
        
        public Route(String routeString, PageReference redirectTo_p) {
            path = routeString;
            redirectTo = redirectTo_p != null ? redirectTo_p : new PageReference('/');
            routePartList = new List<RoutePart>();
            for (String partString_i : splitUrl(routeString)) {
                routePartList.add(new RoutePart(partString_i));
            }
        }
        
        public PageReference mapUrl() {
            PageReference redirect = new PageReference(this.redirectTo.getUrl());
            redirect.getParameters().putAll(this.redirectTo.getParameters());
            redirect.getParameters().putAll(parameterMap);
            return redirect;
        }
        
        public PageReference generateUrl(Map<String, String> parameterMap) {
            String path = this.path;
            for (String key_i : parameterMap.keySet()) {
                path.replaceAll(':' + key_i, parameterMap.get(key_i));
            }
            if (path.indexOf(':') == -1) {
                return new PageReference(path);
            }
            return null;
        }
        
        public Boolean match(PageReference that) {
            String thatUrlString = that.getUrl();
            String thatPathString;
            this.parameterMap = new Map<String, String>();
            if (thatUrlString.contains('?')) {
                thatPathString = thatUrlString.substringBefore('?');
                String thatParametersString = thatUrlString.substringAfter('?');
                List<String> thatParameterList = thatParametersString.split('&');
                for (String parameterString_i : thatParameterList) {
                    if (parameterString_i.contains('=')) {
                        this.parameterMap.put(parameterString_i.substringBefore('='), parameterString_i.substringAfter('='));
                    } else {
                        this.parameterMap.put(parameterString_i, '1');
                    }
                }
            } else {
                thatPathString = thatUrlString;
            }
            List<String> thatPath = splitUrl(thatPathString);
            if (routePartList.size() != thatPath.size()) {
                return false;
            }
            for (Integer i = 0; i < this.routePartList.size(); i++) {
                if (routePartList[i].isParameter) {
                    parameterMap.put(routePartList[i].name, thatPath[i]);
                } else if (routePartList[i].name != thatPath[i]) {
                    return false;
                }
            }
            return true;
        }
        
    }
    
    global PageReference mapRequestUrl(PageReference friendlyUrl) {
        
        for (Route route_i : routeList) {
            if (route_i.match(friendlyUrl)) {
                return route_i.mapUrl();
            }
        }        
        return null;
        
    }
    
    global PageReference[] generateUrlFor(PageReference[] salesforceUrls) {
        
        List<PageReference> friendlyUrls = new List<PageReference>();
        for (PageReference pr_i : salesforceUrls) {
            
            String url = pr_i.getUrl().substringBefore('?');
            Boolean isFound = false;
            for (Route route_i : routeList) {
                if (url == route_i.redirectTo.getUrl().substringBefore('?')) {
                    PageReference friendlyUrl = route_i.generateUrl(pr_i.getParameters());
                    if (friendlyUrl != null) {
                        friendlyUrls.add(friendlyUrl);
                        isFound = true;
                        break;
                    }
                }
            }
            if (!isFound) {
                friendlyUrls.add(pr_i);
            }
            
        }
        
        return friendlyUrls;
        
    }
    
}