import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Maize Farmers Kenya',
      'members': 1250,
      'category': 'Crops',
      'description': 'Share tips and experiences about maize farming',
      'isJoined': true,
      'lastActivity': '2 hours ago',
    },
    {
      'name': 'Dairy Farmers Network',
      'members': 890,
      'category': 'Livestock',
      'description': 'Everything about dairy farming and milk production',
      'isJoined': false,
      'lastActivity': '1 hour ago',
    },
    {
      'name': 'Organic Farming Kenya',
      'members': 567,
      'category': 'Sustainable',
      'description': 'Sustainable and organic farming practices',
      'isJoined': true,
      'lastActivity': '30 minutes ago',
    },
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'John Mwangi',
      'group': 'Maize Farmers Kenya',
      'time': '2 hours ago',
      'content': 'Just harvested 50 bags per acre using the new hybrid seeds. Great results!',
      'likes': 24,
      'comments': 8,
      'isLiked': false,
    },
    {
      'author': 'Mary Wanjiku',
      'group': 'Dairy Farmers Network',
      'time': '4 hours ago',
      'content': 'Looking for advice on treating mastitis in dairy cows. Any recommendations?',
      'likes': 12,
      'comments': 15,
      'isLiked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Groups'),
              Tab(text: 'Feed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGroupsTab(),
            _buildFeedTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showCreateGroupDialog();
          },
          backgroundColor: const Color(0xFF2E7D32),
          icon: const Icon(Icons.add),
          label: const Text('Create Group'),
        ),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2E7D32),
              child: Text(
                group['name'].toString().substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              group['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group['description']),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${group['members']} members',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      group['lastActivity'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  group['isJoined'] = !group['isJoined'];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: group['isJoined'] 
                    ? Colors.grey 
                    : const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: Text(group['isJoined'] ? 'Joined' : 'Join'),
            ),
            onTap: () {
              _showGroupDetails(group);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF2E7D32),
                      child: Text(
                        post['author'].toString().substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${post['group']} • ${post['time']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post['content']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          post['isLiked'] = !post['isLiked'];
                          if (post['isLiked']) {
                            post['likes']++;
                          } else {
                            post['likes']--;
                          }
                        });
                      },
                      icon: Icon(
                        post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                        color: post['isLiked'] ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text('${post['likes']}'),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        _showComments(post);
                      },
                      icon: const Icon(Icons.comment_outlined),
                    ),
                    Text('${post['comments']}'),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _sharePost(post);
                      },
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGroupDetails(Map<String, dynamic> group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                group['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${group['members']} members • ${group['category']}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(group['description']),
              const SizedBox(height: 20),
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text('• New member joined 1 hour ago'),
              const Text('• 3 new posts today'),
              const Text('• Weekly discussion starts tomorrow'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                      child: Text(group['isJoined'] ? 'View Posts' : 'Join Group'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComments(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildComment('Sarah K.', '2 hours ago', 'Great results! Which variety did you use?'),
                  _buildComment('Peter M.', '1 hour ago', 'I got similar results with DH04 variety'),
                  _buildComment('Grace W.', '30 min ago', 'Thanks for sharing! Very helpful.'),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF2E7D32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(String author, String time, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF2E7D32),
            child: Text(
              author.substring(0, 1),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post shared!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Group Name',
                hintText: 'e.g., Tomato Farmers Nakuru',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'What is this group about?',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Group created successfully!'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
