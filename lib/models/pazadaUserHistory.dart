import 'package:cloud_firestore/cloud_firestore.dart';


class PazadaUserHistoryModel{
  String pazadaHistoryID;
  String service_type;
  String driverID;
  String driver_name;
  String driver_phone;
  String pickup_address;
  Timestamp created_at;
  String destination_address;

  String price;

  PazadaUserHistoryModel(
      {this.pazadaHistoryID,
        this.service_type,
        this.driverID,
        this.driver_name,
        this.driver_phone,
        this.pickup_address,
        this.created_at,
        this.destination_address,

        this.price
      });

  PazadaUserHistoryModel.fromJson(Map<String, dynamic> json){

    pazadaHistoryID = json["pazadaHistoryID"];
    service_type = json["service_type"];
    driverID = json["driverID"];
    driver_name = json["driver_name"];
    driver_phone = json["driver_phone"];
    pickup_address = json["pickup_address"];
    created_at = json["created_at"];
    destination_address = json["destination_address"];
    price = json["price"];


  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["pazadaHistoryID"] = pazadaHistoryID;
    data["service_type"] = service_type;
    data["driverID"] = driverID;
    data["driver_name"] = driver_name;
    data["driver_phone"] = driver_phone;
    data["pickup_address"] = pickup_address;
    data["created_at"] = created_at;
    data["destination_address"] = destination_address;
    data["price"] = price;


    return data;
  }
}