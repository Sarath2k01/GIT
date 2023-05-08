class ResourceFinder{
  String? name;
  String? ip;
  String? type;
  ResourceFinder({this.name,this.ip , this.type});
}

List<ResourceFinder> mylist = [
  ResourceFinder(name: "Sanity Node",ip:"10.74.12.53" ,type: "Selenoid" ),
  ResourceFinder(name: "Regression Node ",ip:"10.74.132.5" ,type: "Selenoid"),
  ResourceFinder(name: "Fraud Node ",ip:"10.174.112.5" ,type: "GGR"),
  ResourceFinder(name: "ud Node ",ip:"10.1.112.5" ,type: "Jenkins" ),
];