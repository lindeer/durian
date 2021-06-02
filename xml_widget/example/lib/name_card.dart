
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NameCardPage extends StatefulWidget {

  @override
  _NameCardState createState() => _NameCardState();
}

class _NameCardModel {
  String? avatar;
  String name;
  String? status;
  String? statusIcon;
  String? nickname;
  String? job;
  String empno;
  String email;
  String? city;
  String? department;
  String? superior;
  bool self = false;

  _NameCardModel({
    required this.name,
    required this.empno,
    required this.email,
  });
}

final defaultAvatar = Image.asset('default_avatar.webp');

class _NameCardState extends State<NameCardPage> {
  late _NameCardModel _nameCard;

  @override
  void initState() {
    super.initState();

    _nameCard = _NameCardModel(name: "test9", empno: "test9_dichatv_p", email: "test9_dichatv_p@didichuxing.com",)
      ..avatar = "https://s3-gz01.didistatic.com/dchat-gz/cPs9U6UXizhaNq39hIFXti7Rdyz9yKmSexVpJr8Ju0BJ2s3yIu"
      ..job = "工程师"
      ..status = "在家办公"
      ..statusIcon = ":wfh:"
      ..nickname = "fighting!! 😋"
      ..city = "北京市"
      ..self = true
      ..department = "效能平台部/作息平台部/共享技术量效能组"
      ..superior = "柯文婷";
  }

  static const divider = const Padding(
    padding: EdgeInsets.only(left: 20,),
    child: Divider(
      height: 1,
      color: Color(0xFFEEEEEE),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        ListView(
          children: [
            Ink(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ClipOval(
                    child: _nameCard.avatar == null
                        ? defaultAvatar
                        : Image.network(
                      _nameCard.avatar!,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _nameCard.name,
                      style: Theme.of(context).textTheme.headline6?.copyWith(color: Color(0xFF111111)),
                    ),
                  ),
                  if (_nameCard.job?.isNotEmpty ?? false) Text(
                    _nameCard.job ?? '',
                    style: Theme.of(context).textTheme.caption?.copyWith(color: Color(0xFF666666)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: const Color(0xFFF8EBE4),
                          shape: const CircleBorder(),
                          onPressed: () {},
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: const Icon(
                            Icons.star_border,
                            size: 20,
                            color: Color(0xFFFC8C4E),
                          ),
                        ),
                        MaterialButton(
                          color: const Color(0xFFF8EBE4),
                          shape: CircleBorder(),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          onPressed: () {},
                          child: Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: const Color(0xFFFC8C4E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20).copyWith(bottom: 0),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: _nameCard.self
                        ? const BorderSide(width: 1.0, style: BorderStyle.solid, color: Color(0xFFEEEEEE),)
                        : BorderSide.none,
                  ),
                  backgroundColor: _nameCard.self ? null : Colors.grey[200],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _nameCard.status ?? '',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_nameCard.self) Icon(
                        Icons.edit,
                        color: Color(0xFF9E9E9E),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ..._buildItem(context, '昵称', _nameCard.nickname),
            ..._buildItem(context, '工号', _nameCard.empno),
            ..._buildItem(context, '邮箱', _nameCard.email),
            ..._buildItem(context, '城市', _nameCard.city),
            ..._buildItem(context, '部门', _nameCard.department),
            ..._buildItem(context, '上级', _nameCard.superior),

            SizedBox(
              height: 80,
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: _showDialog,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFF3D3D3D),
                ),
                child: Text(
                  '发消息',
                  style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return Material(
      child: body,
    );
  }

  List<Widget> _buildItem(BuildContext context, String label, String? name) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
        child: Text(
          label,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(color: Color(0xFF999999)),
        ),
      ),
      InkWell(
        onTap: () {
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            name ?? '',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(color: Color(0xFF333333)),
          ),
        ),
      ),
      divider,
    ];
  }

  void _showDialog() {
    final style = TextButton.styleFrom(minimumSize: Size.fromHeight(56));
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(onPressed: () {}, child: Text("a"), style: style,),
              Divider(height: 1,),
              TextButton(onPressed: () {}, child: Text("b"), style: style,),
              Divider(height: 1,),
              TextButton(onPressed: () {}, child: Text("c"), style: style,),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextButton(onPressed: () {}, child: Text("d"), style: style,),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            type: MaterialType.transparency,
            child: content,
          ),
        );
      }
    );
  }
}
