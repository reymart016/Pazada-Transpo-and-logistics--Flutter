import 'package:flutter/material.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/models/pazadaSellers.dart';
import 'package:pazada/widgets/pazabuy_screen/menu_screen.dart';


class InfoDesignWidget extends StatefulWidget {

  PazadaSellers model;
  BuildContext context;
  InfoDesignWidget({this.model, this.context});
  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          staticLocation = widget.model.location;
          sellerid = widget.model.uId;
          sellername = widget.model.userName;
          sellerphone = widget.model.userNumber;
        });
        print(":::::::");
            print(widget.model.uId);

        print(":::::::");
        Navigator.push(context, MaterialPageRoute(builder: (c) => Menuscreen(model: widget.model)));
      },
      child: Padding(
        padding:  EdgeInsets.all(5),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4,
              thickness: 3,
              color: Colors.grey,),
              SizedBox(height: 5,),
              Image.network(widget.model.thumbnailUrl,
                height: 220,
              fit: BoxFit.cover,),
              SizedBox(height: 1,),
              Text(widget.model.userName,
              style: TextStyle(
                color: Colors.amber,
                fontFamily: 'bolt-bold',
                fontSize: 20,
              ),),
              Text(widget.model.userNumber,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'bolt',
                  fontSize: 14,
                ),),

            ],
          ),
        ),
      ),

    );
  }
}
