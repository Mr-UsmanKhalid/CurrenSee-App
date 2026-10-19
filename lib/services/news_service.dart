import '../models/news_model.dart';

/// The eProject spec calls for "news and articles related to currency
/// markets". Since no news API key was specified, this ships a curated,
/// realistic local feed. Swap [fetchNews] for a real /api/news/* call
/// whenever the backend team wires one up.
class NewsService {
  Future<List<NewsModel>> fetchNews() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return [
      NewsModel(
        id: 1,
        title: 'Dollar steadies as markets await central bank signals',
        summary: 'The USD held firm against a basket of major currencies ahead of key policy meetings.',
        content:
            'The US Dollar Index traded in a narrow range this week as investors positioned '
            'ahead of upcoming central bank commentary. Analysts note that rate-path expectations '
            'remain the dominant driver of near-term currency moves, with traders watching '
            'employment and inflation data closely for fresh direction.',
        source: 'CurrenSee Markets Desk',
        publishedAt: now.subtract(const Duration(hours: 3)),
        trend: 'up',
      ),
      NewsModel(
        id: 2,
        title: 'Euro slips on softer manufacturing data',
        summary: 'Eurozone factory activity contracted more than expected, weighing on the single currency.',
        content:
            'The Euro eased against major peers after purchasing managers\' index readings across '
            'the bloc came in below forecasts. Economists caution that continued weakness in '
            'manufacturing could keep the currency under pressure in the short term, though '
            'services-sector resilience has offered some support.',
        source: 'CurrenSee Markets Desk',
        publishedAt: now.subtract(const Duration(hours: 8)),
        trend: 'down',
      ),
      NewsModel(
        id: 3,
        title: 'Emerging market currencies see mixed flows',
        summary: 'Capital flows into emerging markets remained mixed as risk appetite fluctuates.',
        content:
            'A mixed picture emerged across emerging market currencies this week, with some gaining '
            'on stronger commodity prices while others slipped amid broader risk-off sentiment. '
            'Portfolio managers highlight the importance of diversification as global rate '
            'differentials continue to evolve.',
        source: 'CurrenSee Markets Desk',
        publishedAt: now.subtract(const Duration(hours: 20)),
        trend: 'neutral',
      ),
      NewsModel(
        id: 4,
        title: 'Pound gains on stronger-than-expected retail sales',
        summary: 'GBP found support after UK retail figures beat consensus estimates.',
        content:
            'Sterling advanced against the dollar and euro following data showing UK consumer '
            'spending held up better than economists had projected. The reading offers a modest '
            'counterpoint to concerns about slowing momentum in the broader economy.',
        source: 'CurrenSee Markets Desk',
        publishedAt: now.subtract(const Duration(days: 1, hours: 4)),
        trend: 'up',
      ),
      NewsModel(
        id: 5,
        title: 'Yen volatility rises amid intervention speculation',
        summary: 'Traders remain alert to the possibility of official action to support the yen.',
        content:
            'The Japanese Yen swung in a wide range this week as speculation mounted over possible '
            'intervention by monetary authorities. Options markets are pricing in elevated '
            'volatility, and desks are advising caution around key technical levels.',
        source: 'CurrenSee Markets Desk',
        publishedAt: now.subtract(const Duration(days: 2)),
        trend: 'down',
      ),
    ];
  }
}
