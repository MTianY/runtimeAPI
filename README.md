# runtime API

### 和 类 相关的 API

#### 1. 传入一个对象, 获取其 `isa` 指向的 Class 对象.
```objc
Class object_getClass(id obj)
```

如

```objc
TYPerson *person = [[TYPerson alloc] init];
[person run];
        
// 传入一个对象,获取其 isa 指向的 Class 对象
// 传入的 person 实例对象,其 isa 指向的是其类对象 TYPerson
NSLog(@"%p---%p",object_getClass(person), [TYPerson class]);
// 传入的类对象[TYPerson class],则object_getClass 得到的就是其元类对象
NSLog(@"%p---%p",object_getClass([TYPerson class]), [TYPerson class]);
```

#### 2.设置 `isa` 指向的 Class

```objc
Class object_setClass(id obj, Class cls)
```

如:

```objc
// 修改了 person 对象的 isa 指向,现在其 isa 指向 TYAnimal 这个类对象
object_setClass(person, [TYAnimal class]);
// 调用这个方法,看打印
[person run];
```

打印结果:

```c
// 因为 person 的 isa 已经指向 TYAnimal 了,所以执行 run 方法时是去 TYAnimal 这个类对象的方法列表里去找方法的.
-[TYAnimal run]
```

#### 3.判断一个 OC 对象是否是 Class 类型

```objc
BOOL object_isClass(id obj)
```

如:

```objc
NSLog(
@"%d---%d----%d",
object_isClass(person),
object_isClass([TYPerson class]), 
object_isClass(object_getClass([TYPerson class])));
```

打印结果:

```c
// person 是实例对象,不是一个类对象
// TYPerson 是类对象
// object_getClass([TYPerson class]) 得到的 元类对象,也是 Class 类型
0---1----1
```

#### 4. 动态创建一个类 

```objc
/**
 * 参数1: superclass, 父类
 * 参数2: name, 类名
 * 参数3: extraBytes, 额外的内存空间
 */
Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
```

如: 

```objc
Class newClass = objc_allocateClassPair([NSObject class], "TYDog", 0);
```

#### 5.注册这个类

一般和`动态创建类`结合使用.动态创建完成之后,注册这个类.

类,注册完毕,就相当于类对象和元类对象里面的结构已经定义好了.所以动态创建类,动态添加成员变量,都要在注册类之前进行.

- 因为成员变量在 `class_ro_t` 这个结构体中,是只读的,所以不能为一个结构已经确定的类去动态的添加成员变量.
- 但是方法、协议、属性等等是可以动态添加的,就是说动态添加方法可以在注册类后面再写,因为方法是在`class_rw_t`这个结构体中.

```objc
objc_registerClassPair(Class *cls)
```

如:

```objc
// 动态创建这个类
Class newClass = objc_allocateClassPair([NSObject class], "TYDog", 0);
// 注册这个类
objc_registerClassPair(newClass);
```

```objc
// 动态创建这个类
Class newClass = objc_allocateClassPair([NSObject class], "TYDog", 0);
   
// 动态添加成员变量
class_addIvar(newClass, "_age", 4, 1, @encode(int));
class_addIvar(newClass, "_weight", 4, 1, @encode(int));
   
// 动态添加方法
class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
   
// 注册类
objc_registerClassPair(newClass);
   
// 使用动态创建的这个类
id dog = [[newClass alloc] init];
[dog setValue:@10 forKey:@"_age"];
[dog setValue:@30 forKey:@"_weight"];
[dog run];
   
NSLog(@"%@---%@",[dog valueForKey:@"_age"], [dog valueForKey:@"_weight"]);
```

