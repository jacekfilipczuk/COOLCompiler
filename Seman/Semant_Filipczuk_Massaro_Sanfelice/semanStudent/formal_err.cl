

class A {
    a : Int;

    init(x : Int, y : Bool): Int{
	a
    };

    init2(x : Int): Bool{
	true
    };
};

class B inherits A {
    b : Int;

    init(x : Bool, y : Int): Int{
	a
    };
   
    init2(): Bool{
	true
    };
};

class Main {

    main(): SELF_TYPE{
	self
    };
};
