
// Motokoya hoşgeldiniz. 1.DERS

// actor nedir --> canister --> smart contract

// actor -> actor [projeismi] yzabiliriz

//importlar
//import Text "mo:base/Text";
//import Debug "mo:base/Debug";
//import Nat "mo:base/Nat";
//import Iter "mo:base/Iter";
//import Map "mo:base/HashMap";


// degişkenler -> let -> immutable (değiştirilemez)
// var -> mutable (değiştiirilebilir)

//Type language

//actor {
  
//let isim: Text = "kerem";
//let soyisim: Text = "keskin";

//Debug.print(debug_show (isim));

//////////////////////////////////////////////
//2.DERS 1. PROJE

//importlar



//};


// Sample Smart Contract
//actor { //canister actor demek yani smart contract e actor diyoruz
  //  type Name = Text;
  //  type Phone = Text;

  //  type Entry = {
  //      desc: Text;
  //      phone: Phone;
  //  };

    // variable (değişkenler)

  //  let phonebook = Map.HashMap<Name, Entry>(0, Text.equal, Text.hash); //immutable, map anahtar hashmap kasa

// 0 olan nat demek natural, text.equal kontrol için uyumlu mu değil mi daha sonra text.hash ile depoya gönderiyor
// şifreleme için djb2 alg. kullanılıyor
    //fonksiyonlar 
  //  public func insert(name: Name, entry: Entry) : async () { //kullanıcıdan bilgi alıyoruz
  //      phonebook.put(name, entry);


  //  };
  //  public query func lookup(name: Name) : async ?Entry { //insert edilen bilgi girilmiş mi kontrol için ? nin anlamı ne olursan ol gel demek
  //      phonebook.get(name); // return phonebook.get(name); ile aynı
  //  };



//};

// 2.DERS 2. PROJE
// importlar 
import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

actor Assistant {

  type ToDo = {
    description: Text;
    completed: Bool;


  };

  func natHash(n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))


  }; //doğal sayılar hashlensin fonksiyonu


  // değiken oluşturalım
  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash); //map anahtar hashmap kasa
  var nextId: Nat = 0;

  public query func getTodos() : async [ToDo] {  //gelen bilgileri array olarak döndüdr
    Iter.toArray(todos.vals());



  };

  public func addTodo(description: Text) : async Nat {
    let id = nextId;
    todos.put(id, {description = description; completed = false});
    nextId += 1;
    id // return id; de denebilir

  };

  public func completeTodo(id: Nat) : async () { // id check et tamamlanmadıysa ignore et
    ignore do ? {
      let description = todos.get(id)!.description;  // ! işareti ignore u gösteriyor değil demek yani
      todos.put(id, {description; completed = true});


    }
  };

  public query func showTodos() : async Text { // # in anlamı yazılı ifade demek
    var output: Text = "\n_______TO-DOs__________";

    for (todo: ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.completed) {  output #= " +" };


    };
    output # "\n"
    

  };

  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
    func(_, todo) {if (todo.completed) null else ?todo });

  };



};