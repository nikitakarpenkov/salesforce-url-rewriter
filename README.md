# salesforce-url-rewriter
Flexible UrlRewriter implementation for Force.com sites

```java
global class SiteUrlRewriter implements Site.UrlRewriter {
    
    
    List<Route> routeList = new List<Route> {
        new Route('/account', Page.SiteAccountsList), // --> /SiteAccountsList
        new Route('/account/:accountId', Page.SiteAccountView), // --> /SiteAccountView?accountId=0016C000003eH88
        new Route('/account/:accountId/edit', Page.SiteAccountEdit), // --> /SiteAccountEdit?accountId=0016C000003eH88
        new Route('/account/:accountId/contacts/:regionId', Page.SiteAccountContactsList) // --> /SiteAccountContactsList?accountId=0016C000003eH88&regionId=US
    };    

    // ...

}
```

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>