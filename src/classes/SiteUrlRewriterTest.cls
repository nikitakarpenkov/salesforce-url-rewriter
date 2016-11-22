@isTest
public class SiteUrlRewriterTest {
	
    @isTest
    public static void test() {
        SiteUrlRewriter rewriter = new SiteUrlRewriter();
        rewriter.mapRequestUrl(new PageReference('/test'));
        rewriter.generateUrlFor(new List<PageReference> {new PageReference('/test')});
    }
    
    @isTest
    public static void testRoutePositiveMatch() {
		SiteUrlRewriter.Route route = new SiteUrlRewriter.Route('/account/:accountId/', new PageReference('/'));
        System.assert(route.match(new PageReference('/account/00A12345678')));
        System.debug(route.mapUrl().getUrl().contains('accountId=00A12345678'));
    }
    
    @isTest
    public static void testRouteNegativeMatch() {
		SiteUrlRewriter.Route route = new SiteUrlRewriter.Route('/account/edit/:accountId', new PageReference('/'));
        system.debug(route);
        System.assert(!route.match(new PageReference('/account/00A12345678')));
        System.assert(!route.match(new PageReference('/account/edit')));
        System.assert(!route.match(new PageReference('/')));
    }
    
    @isTest
    public static void testSplitUrl() {
        System.assertEquals(0, SiteUrlRewriter.splitUrl('').size());
        System.assertEquals(0, SiteUrlRewriter.splitUrl(' ').size());
        System.assertEquals(0, SiteUrlRewriter.splitUrl('/').size());
        System.assertEquals(0, SiteUrlRewriter.splitUrl('//').size());
        System.assertEquals(1, SiteUrlRewriter.splitUrl('/bla//').size());
        System.assertEquals(1, SiteUrlRewriter.splitUrl('/1').size());
        System.assertEquals(2, SiteUrlRewriter.splitUrl('/1/2/').size());
        System.assertEquals(3, SiteUrlRewriter.splitUrl('/1/2/3').size());
    }
    
}