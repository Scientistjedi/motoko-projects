import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import List "mo:base/List";




actor Superheroes {

  public type SuperheroId = Nat32;

  public type Superhero = {

    name: Text; //süperkahraman isimleri
    superpowers: List.List<Text>; //liste olarak iletsin

  };

  private stable var next: SuperheroId = 0; 

  private stable var superheroes: Trie.Trie<SuperheroId, Superhero> = Trie.empty(); 

  // yüksek seviye API yapacağız

  public func create(superhero: Superhero) : async SuperheroId {
    let superheroId = next;
    next += 1;
    superheroes := Trie.replace(
      superheroes,
      key(superheroId),
      Nat32.equal,
      ?superhero,
    ).0;
    superheroId

  };

  public query func read(superheroId: SuperheroId) : async ?Superhero {

    let result = Trie.find(superheroes, key(superheroId), Nat32.equal);
    result
  };

  public func update(superheroId: SuperheroId, superhero: Superhero): async Bool { //update var mı superherolara bakmak için
    let result = Trie.find(superheroes, key(superheroId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {

      superheroes := Trie.replace(

        superheroes,
        key(superheroId),
        Nat32.equal,
        ?superhero,
      ).0;
    };
    exists
  };

  public func delete(superheroId: SuperheroId): async Bool {
    let result = Trie.find(superheroes, key(superheroId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {

      superheroes := Trie.replace(
        superheroes,
        key(superheroId),
        Nat32.equal,
        null,
      ).0;
    };
    exists

  };
//key oluşturacağız
  private func key(x: SuperheroId): Trie.Key<SuperheroId> {
    { hash = x; key = x };


  };



};
