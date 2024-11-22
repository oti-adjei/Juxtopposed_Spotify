import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // Customize gradient colors as needed
                colors: [Colors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.07,
                  backgroundImage:
                      NetworkImage('https://example.com/avatar.jpg'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Name'),
                          Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 10),
                              Icon(Icons.share),
                            ],
                          ),
                        ],
                      ),
                      Text('100 Followers • 200 Following'),
                      Text('12345678901234567890'), // Or "20 Playlists"
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Friends'),
                    IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {},
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text('You haven\'t added any friends yet.'),
                  ),
                ),
                // Or if there are friends:
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: friends.length,
                //     itemBuilder: (context, index) {
                //       return // ... friend card layout
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey),
            ),
            height: screenHeight * 0.12,
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/logos/spotify_account.png'),
                    Text('Current Plan'),
                  ],
                ),
                Text('Premium Individual',
                    style: TextStyle(color: Colors.green)),
                Text('\$9.99/month'),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Expanded(
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Listening History'),
                    );
                  case 1:
                    return ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings & Privacy'),
                    );
                  case 2:
                  default:
                    return ListTile(
                      leading: Icon(Icons.alarm),
                      title: Text('What\'s New'),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
