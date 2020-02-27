# MT5-STUDY
MT5 study

大道至简  我不希望为了OOD 而 OOD  

MQL 是事件驱动类型的语言   更上层的语言把

### 基础部分 (demo1~2)
我们想来看看一个ea文件  的一些事件函数
```
int OnInit() 
{
    // 全局初始化函数
    return (INIT_SUCCEEDED); // 需返回一个枚举对象
    // return (INIT_FAILED);
}

int OnTick() 
{
    // tick 跳动一次 就会调用一次这个函数
}

void OnDeinit(const int reason) 
{
    // 程序生命周期结束的时候
    EventKillTimer();
}
```

简单函数
```
EventSetTimer(60);   //  60 秒执行一次 onTimer()中的代码  (注意 但onTimer()中代码执行时 OnTick()会阻塞)
EventKillTimer(60);  // 删除定时器

// Sleep(10000);  这个会阻塞其他操作 OnTick也会
printf(TimeToString(TimeLocal(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));  // 这个获取的是本地时间
printf("Server Time: %s",TimeToString(TimeTradeServer(),TIME_DATE|TIME_MINUTES|TIME_SECONDS)); // 获取交易服务器的时间

if (TimeTradeServer() > D'2018.01.01') {
    printf("Kill Timer");
    EventKillTimer();
}
```

订单相关函数
```
void OnTrade() 
{
    // 交易发生时调用这个函数，改变下订单和持仓列表，订单历史记录和交易历史记录时会出现。当交易活动执行挂单，持仓/平仓，停止设置，启动挂单等等，订单和交易历史记录或者仓位和当前订单列表也会相应改变。
}



void  OnTradeTransaction( 
   const MqlTradeTransaction&    trans,        // 交易结构 
   const MqlTradeRequest&        request,      // 请求结构 
   const MqlTradeResult&         result        // 结果结构 
   )
  {
    // 
   
  }

```

其他鉴定函数
```
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
    //  gui 实践的监听
   if (id == CHARTEVENT_CLICK) {
      Alert("你单机了界面"," x: ",lparam," y: ",dparam);
   }
   
  }


//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
    // 市场深度发生改变的适合  (量价)
    printf(symbol," 货币 市场深度发生改变");  
   
  }
  // 市场深度监听需要初始化 MarketBookAdd(Symbol()); // 初始化监听市场深度  Symbol()自动适用你ea当前运行的货币
```

### EA编写时  常用函数1
```
string timeString = "2020.12.01";
datetime time = StringToTime(timeString);
printf(time);
printf(TimeToString(time));

string as = StringFormat("%s hello","world");
   
```

### 字符串处理函数
- StringFind    查询
- StringSubstr  截取
- StringSplit   拼接
```
// StringFind
   string as = StringFormat("%s hello","world");
   int als = StringFind(as,"hello",0); // 目标  需要查询的内容  起始位置
   printf(als);

// StringSubstr 截取
   string as1 = StringSubstr(as,1,2); // 目标 起始位置 结束位置
   printf(as1);

// StringSplit 拼接
   string test1 = "1,2,3,4,5,6,7,8,9";
   string c2[]; // 定义一个数组 c2
   a = StringSplit(test1,",",c2); // 目标 特征符 目的地
   printf(a);
```

### 外部接受用户输入参数
```
#property script_show_inputs;  // 编写脚本框默认是不显示的需要用这个把它调出来

// 操作 // 注释     
input double lots=0.1;// this is test  

```

### MQL中级语法 (demo3)
```
### 持久化

   // 获取Mql程序的信息 (info id)
   name = MQLInfoString(MQL_PROGRAM_NAME) + Symbol() + IntegerToString(majic);
   
   if (GlobalVariableCheck(name) != true) {
   GlobalVariableSet(name,0); // 持久化  里面应该是应该HASHMAP
   }

### 枚举类型
  enum duokong 
  {
    duo,// 多
    kong,// 空
    duokong,// 多&空
  };  
  input duokong duokongName=duo;// 多空

### 结构体
  // 结构体
  struct kbar 
  {
    double open;
    double close;
    double hight;
    datetime time;
  };

 // 结构体声明与赋值
   kbar kb;
   kb.open=1.1;
   kb.time = D'2020.01.01';
   kb.close = 1.2;

### 数组

   double a[]; // 空的 可变数组
   double a1[10]; // 不可变数组
   
   double c = a1[0];
   printf("a1 0 : %f",c);
   
   ArrayResize(a,2); // 调整动态数组大小 1.数组2.new数组大小
   a[0] = 1.1;

   # 操作价格数据 
   MqlRates rates[];
   ArraySetAsSeries(rates,true); // 序列化 索引
   CopyRates(NULL,0,0,100,rates); // 分配数据
   double op = rates[0].open;

### 循环语句
    int acs = 0;
    while(acs < 10) {
        acs++;
        printf(acs);
    }

    for(int i =0;i<100;i++) {
        printf(i);
    }
```

### MQL高级语法  [demo4~5]
class .Mql结尾
```
神奇的const  (有点像rust的那个什么函数  传入之后就变成了常量)
class A {
public:
  void setName(const string name);    
  void setAget() const {  // 这个const 是 这个fuction的操作不会对class中的成员变量做改变
    // pass
  }
}

class People
  {
public:
   string            name;
   int               age;
   string            getName()
     {
      return this.name;
     }
   // 函数重载
   string            getName(string hel)
     {
      return hel + " " + this.name;
     }

   // 构造函数 和class名称一样
                     People(string name,int age)
     {
      this.name = name;
      this.age = age;
      printf(__FUNCTION__); // __FUNCTION__ 内置变量  函数名称
     }
   // 析构函数
                    ~People()
     {
      // 次类执行完毕 会执行这个   (mql 没有内存回收机制 是需要在这里手动回收内存  傻逼mt5 为什么不直接接入py呢)
     }

   static int        Chen(int x,int y)   // 静态函数不需要声明可以直接调用
     {
      return x * y;
     }
  };
```
class 2 
```
继承

class Animal
  {
public:
   string            race;
   int               age;
    Animal() {}
                     Animal(string race,int age)
     {
      this.race = race;
      this.age = age;
     }
   void              eat()
     {
      printf("eat... race:%s  age:%d",this.race,this.age);
     }
  };


// #include <newClass/class1.mqh>
#include "class1.mqh"
class Humanity : public Animal
  {
public:
   string            name;
                     Humanity(string name,string race,int age)
     {
      this.name = name;
      this.race = race;
      this.age = age;
     }
   void              work()
     {
      printf(this.name + " work ...");
     }
  };

实例化 子类时 首先会调用父类的构造函数


#include <newClass/class2.mqh>
void OnStart()
  {
   Humanity once("wang","humanity",18);
   once.eat();
   once.work();
   
  }

抽象类与虚函数
  virtual void add() = 0;  // 这个就是虚函数
  如果一个类中只有虚函数  这个类 就是抽象类

```

### 获取 软件信息  账户信息  货币数据  [demo6]
获取账户相关信息
```
AccountInfoInterger()
AccountInfoDouble()
AccountInfoString()
```
获取终端信息
```
TerminalInfoInterger()
TerminalInfoDouble()
TerminalInfoString()
```
获取MT5信息
```
MQLInfoInteger()
MQLInfoString()
```

获取货币信息
``` 
Symbol()  // 返回当前货币对名称
Period()  // 当前图标周期
Digits()  // 当前价格精度 (小数点数量)
Point()   // 当前交易品种大小点
SymbolInfoInterger()
SymbolInfoDouble()
SymbolInfoString()
```