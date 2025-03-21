import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
     final List<NewsItem> newsItems = [
      NewsItem(
        title: "Design Thinking Workshop",
        description: "Join our virtual workshop on applying design thinking to solve complex innovation challenges.",
        imageUrl: "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        category: "Workshop",
        date: "Tomorrow, 2:00 PM",
      ),
      NewsItem(
        title: "Startup Funding Trends 2023",
        description: "Discover which innovation sectors are receiving the most funding this year and why.",
        imageUrl: "https://images.unsplash.com/photo-1579532537598-459ecdaf39cc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        category: "Market Trends",
        date: "Posted 2 days ago",
      ),
      NewsItem(
        title: "Sustainable Innovation Challenge",
        description: "Apply now for our challenge to create solutions for environmental sustainability.",
        imageUrl: "https://images.unsplash.com/photo-1536599424071-0b215a388ba7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        category: "Challenge",
        date: "Applications close in 5 days",
      ),
      NewsItem(
        title: "AI in Product Development",
        description: "How leading companies are using artificial intelligence to revolutionize their product development cycles.",
        imageUrl: "https://images.unsplash.com/photo-1535378917042-10a22c95931a?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        category: "Technology",
        date: "Posted 1 week ago",
      ),
      NewsItem(
        title: "Innovation Network Meetup",
        description: "Connect with fellow innovators in your area at our next networking event.",
        imageUrl: "https://images.unsplash.com/photo-1540304453527-62f979142a17?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        category: "Event",
        date: "Next Tuesday, 6:30 PM",
      ),
    ];
    
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          return NewsCard(newsItem: newsItems[index]);
        },
      ),
    );
  }
}

class NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String date;

  NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
  });
}

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;

  const NewsCard({
    super.key,
    required this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with fixed aspect ratio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 14 / 16,
                  child: Image.network(
                    newsItem.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Content below the image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        newsItem.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        newsItem.description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black54, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          newsItem.date,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
