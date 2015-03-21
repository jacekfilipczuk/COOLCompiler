--cicli nel grafo delle classi
-- A inherits Int => error

class A inherits Int{
    a : Int;
};

class B inherits Bool {
    b : Int;
};

class C inherits String {
    c : Int;
};

class D inherits SELF_TYPE {
    d : Int;	
};

class E inherits F {
    e : Int;	
};

class Main inherits IO{

    main(): SELF_TYPE{
       {
	out_string("hello!");
	self;
       } 
    };
};
