-- errori su metodi e attributi


class A {
    a : Int;
    init(): Int {
	a
    };

    tipo_parametri(x : Int, y : Bool): Int {
	a
    };
};

class B inherits A {
    b : Int;
    a : Int;

    self : String;

    metodo_richiamato(i : Int) : Bool {
	true;
    };

    tipo_parametri(x : Bool, y : Int): Int {
	a
    };

    metodoB() : SELF_TYPE{
	self
    };

     init(): Int {
	b
    };
};

class C inherits A {
    c : Int;
    a : Bool;

    init(): Bool {
	a
    };
};

class D inherits B {
    d : Int;

    tipo_parametri(): Int {
	a
    };
};




class Main {

    main(): SELF_TYPE{
	b : B <- new B();

	b.metodo_richiamato(5);

	b.metodo_richiamato();

	b.metodo_inesistente();
	self
    };
};
