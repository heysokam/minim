// https://stackoverflow.com/questions/13716913/default-value-for-struct-member-in-c

struct MyStruct {
  int flag;
}
MyStruct_default = {3};

// However, the above code will not work in a header file - you will get error: multiple definition of 'MyStruct_default'.
// To solve this problem, use extern in the header file:
struct MyStruct {
  int flag;
};
extern const struct MyStruct MyStruct_default;
// And in the c file:
const struct MyStruct MyStruct_default = {3};
