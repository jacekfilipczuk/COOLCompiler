-- duplicate class and inherits from undefined class

class A inherits D {
    a : Int;
};

class A  {
    b : Int;
};



class Main {

    main(): SELF_TYPE{
	self
    };
};
