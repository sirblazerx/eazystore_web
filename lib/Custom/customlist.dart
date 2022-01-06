import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    Key key,
    this.onTap,
    this.title,
    this.thumbnail,
    this.user,
    this.description,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget thumbnail;
  final String title;
  final String user;
  final String description;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: widget.thumbnail,
            ),
            Expanded(
              flex: 2,
              child: _VideoDescription(
                title: widget.title,
                user: widget.user,
                description: widget.description,
              ),
            ),
            // IconButton(
            //   color: Colors.green,
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => ManageStory()),
            //     );
            //   },
            //   icon: Icon(Icons.more_vert),
            //   iconSize: 16.0,
            // ),
          ],
        ),
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    Key key,
    this.title,
    this.user,
    this.description,
  }) : super(key: key);

  final String title;
  final String user;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            user,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$description ',
            style: const TextStyle(fontSize: 10.0),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ...

Widget build(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(8.0),
    itemExtent: 106.0,
    children: <CustomListTile>[
      CustomListTile(
        user: 'Flutter',
        description: 'meh',
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
        ),
        title: 'The Flutter YouTube Channel',
      ),
      CustomListTile(
        user: 'Dash',
        description: "meep",
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.yellow),
        ),
        title: 'Announcing Flutter 1.0',
      ),
    ],
  );
}
