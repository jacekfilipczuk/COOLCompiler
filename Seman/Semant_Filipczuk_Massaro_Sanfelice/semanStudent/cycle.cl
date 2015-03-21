--cicli nel grafo delle classi
-- D<B<A e A<D

class A inherits D {
    a : Int;
};

class B inherits A {
    b : Int;
};

class C inherits A {
    c : Int;
};

class D inherits B {
    d : Int;
};




class Main {

    main(): SELF_TYPE{
	self
    };
};
