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
```

### 获取市场报价中商品信息，所有品种 [demo7]
获取市场信息
```
SymbolInfoInterger()
SymbolInfoDouble()
SymbolInfoString()
```
### 市场深度 [demo8]
```
   // 订阅货币对市场深度
   if (MarketBookAdd(Symbol())) {
      printf("订阅 %s 市场深度成功",SymbolName(Symbol(),true));
   }else {
      printf("订阅失败");
   }
   // MarketBookRelease(Symbol()) 取消订阅

    //  获取当前市场深度
    MqlBookInfo book[];
    if (MarketBookGet(Symbol(),book)) {
        int size = ArraySize(book);
        for (int i=0;i<size;i++) {
          Print(i+":",book[i].price  
                +"    Volume = "+book[i].volume,
                " type = ",book[i].type);
        }
    }
```

### K线序列  K线数据  调用指标 [demo9]
```
  // 获取高开低收价格
   double open[];  // 数据容器
   ArraySetAsSeries(open,true); // 数据倒装 最右边为0
   // 获取K线开盘数据 Symbol(),0自动适应时间周期,开始位置,获取数量,容器
   CopyOpen(Symbol(),0,0,10,open); 
   printf("当前货币0位置价格: %f",open[0]);
   
   if (kdata.getOpen(10)) {
      printf("当前货币0位置价格: %f",kdata.open[0]);
   }
   
   // 获取IMA均线
   double ma[];
   ArraySetAsSeries(ma,true);
   int ma_h; // 句柄
      // 货币,周期,平均周期,平移,平滑类型,
   ma_h = iMA(Symbol(),0,12,0,MODE_SMA,PRICE_CLOSE);// 12日均线 SMA  以收盘价计算
      // 拷贝数据 句柄,指标缓冲区数,开始位置,获取数量,容器
   CopyBuffer(ma_h,0,0,10,ma);
   IndicatorRelease(ma_h); // 释放句柄
   printf("MA 1: %f",ma[1]);

   // 调用第三方指标   货币,周期,指标名称, 指标参数...
   int point3 = iCustom(Symbol(),0,"CCI",14);
   double cci[];
   ArraySetAsSeries(cci,true);
   CopyBuffer(point3,0,0,10,cci);
   IndicatorRelease(point3);
   printf("CCI 1 :%f",cci[1]);
```

### 脚本开发实战 [demo10]
```
   // 买单 (立即执行)
   // params: 货币,手数,止损,止盈,注释,majic,滑点(小点)
   // result: 订单id
   ulong buy(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
      MqlTradeRequest request = {0};
      MqlTradeResult result = {0};
      
      // OrderSend
      request.action = TRADE_ACTION_DEAL; // 下单类别 市价 
      request.symbol = symbol; // 交易品种
      request.type = ORDER_TYPE_BUY; // 下多单
      request.comment = com;
      request.tp = tp; // 止盈
      request.magic = majic;
      request.volume = lots; // 下单量
      request.deviation = deviation;// 滑点  100 小点 就是 10点
      request.price = SymbolInfoDouble(symbol,SYMBOL_ASK); // 设置开单价格
      request.sl = request.price - sl * Point(); // 止损
      request.tp = request.price + sl * Point(); // 止盈
      
      if (OrderSend(request,result)) {
         return result.order;
      }
      
      
      PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      return 0;
   }

   // 修改止损止盈
   // parars: 
   void modfiySlTp(string symbol,ENUM_POSITION_TYPE type,double sl,double tp) {
      int total = PositionsTotal();
      for(int i=total-1;i>=0;i--) {
         ulong id = PositionGetTicket(i);
         if (id > 0){
            if (PositionGetString(POSITION_SYMBOL) == symbol) {
               MqlTradeRequest request = {0};
               MqlTradeResult result = {0};
               request.action = TRADE_ACTION_SLTP; // TRADE_ACTION_MODIFY 修改挂单价格 和止损止盈
               request.position = id;
               request.symbol = symbol;
               if (sl != 0)
                  {
                     request.sl = NormalizeDouble(sl,Digits());
                  } 
               if (tp != 0)
                  {
                     request.tp = NormalizeDouble(tp,Digits());
                  }
               if (type == POSITION_TYPE_BUY) {
                  if (!OrderSend(request,result)) {
                    printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                    //--- 操作信息
                    printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
                  }
               }else {
                  if (!OrderSend(request,result)) {
                    printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                    //--- 操作信息
                    printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
                  }
               }
            }
         }
      }
   }
   
   // 删除所有挂单
   void delPending(string symbol) {
      int total = OrdersTotal();
      for (int i=total-1;i>=0;i--) {
         ulong id = OrderGetTicket(i);
         if (id > 0) {
            if (OrderGetString(ORDER_SYMBOL) == symbol) {
               MqlTradeRequest request = {0};
               MqlTradeResult result = {0};
               request.action = TRADE_ACTION_REMOVE;
               request.order = id; // 对未生效订单做操作用这个
               request.symbol = symbol;
               
               if (!OrderSend(request,result)) {
                 printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                 //--- 操作信息
                 printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
               }
            }
            
         }
      }
   }
```

### 指标开发实战01 [demo11]
基础
```
// #property indicator_separate_window  // 画在辅图上面
 #property indicator_chart_window       // 画在主图上
#property indicator_minimum -2       // min
#property indicator_maximum 2        // max
#property indicator_buffers 3        // 数据缓冲区
#property indicator_plots   3        // 画 plot 的数量
//--- plot line1
#property indicator_label1  "line1"     // 名称
#property indicator_type1   DRAW_LINE   // 类型
#property indicator_color1  clrRed      // color
#property indicator_style1  STYLE_SOLID // 实线还是虚线
#property indicator_width1  1           // 线宽度
//--- plot arrow1
#property indicator_label2  "arrow1"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot his1
#property indicator_label3  "his1"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrWhite
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- indicator buffers
double         line1Buffer[];   // 数据缓冲区定义
double         arrow1Buffer[];
double         his1Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,"设置指标名称");
   IndicatorSetInteger(INDICATOR_DIGITS,Digits()); // 设置精度
//--- indicator buffers mapping
   SetIndexBuffer(0,line1Buffer,INDICATOR_DATA);// 缓冲区绑定
   SetIndexBuffer(1,arrow1Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,his1Buffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(1,PLOT_ARROW,204); // 设置箭头样式 Wingdings
   //ArraySetAsSeries(line1Buffer,true);
   //ArraySetAsSeries(his1Buffer,true); 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,        // 目前图标k线数量
                const int prev_calculated,    // 指标已经计算了多少根k线
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {   
//---
   //ArraySetAsSeries(open,true);
//   int total = 0;
//   if (prev_calculated == 0) {
//      total = rates_total;
//   }else {
//      total = rates_total - prev_calculated + 1;
//   }
//   for (int i=0;i<(total);i++) {
//      line1Buffer[i] = open[i];
//   }
//   
//   for (int i = rates_total - 1;i>=prev_calculated;i--) {
//      arrow1Buffer[i] = close[i];
//   }

   // 调用系统自带的
   int ma_point = iMA(Symbol(),0,12,0,MODE_SMA,PRICE_CLOSE);
   CopyBuffer(ma_point,0,0,rates_total,arrow1Buffer);
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
```

### 指标开发02 [demo12]
变色线与金叉死叉
```
double ma5[];
   double ma10[];
   CopyBuffer(ma5_proint,0,0,rates_total,ma5);
   CopyBuffer(ma10_proint,0,0,rates_total,ma10);
   int start = 0;
   if(prev_calculated > 0)
     {
      start = prev_calculated - 1;
     }
   for(int i = start; i<rates_total; i++)
     {
      line1Buffer[i] = ma5[i];
      line2Buffer[i] = ma10[i];
      if(open[i] > ma5[i])
        {
         line1Colors[i] = 1; // 转换颜色
         line2Colors[i] = 1;
        }
        
        if (i != 0) {
         if (line1Buffer[i-1] < line2Buffer[i-1] && line1Buffer[i] >= line2Buffer[i]) {
            upBuffer[i] = line1Buffer[i] - 100 *Point();
         }
         if (line1Buffer[i-1] > line2Buffer[i-1] && line1Buffer[i] <= line2Buffer[i]) {
            downBuffer[i] = line1Buffer[i] + 100 *Point();
         }
        }
     }
```
### 指标开发03 [demo13]
超炫MACD实战 详见demo13

### 跨时间周期 [demo14]
```
   if (kNum > rates_total) {
      printf(rates_total);
   }
   double small_ma[];
   double big_ma[];
   datetime small_time[];
   ArraySetAsSeries(small_ma,true);
   ArraySetAsSeries(big_ma,true);
   ArraySetAsSeries(small_time,true);
   ArraySetAsSeries(time,true);
   CopyBuffer(small_ma_point,0,0,kNum,small_ma);
   CopyBuffer(big_ma_point,0,0,kNum,big_ma);
   CopyTime(Symbol(),tf,0,kNum,small_time);
   int k = 0 ;
   for (int i=0;i<kNum;i++) {
      if (time[i] < small_time[k]) {  // 如果当前小k线 在大k线下面
         k++;
      }
      small_lineBuffer[i] = small_ma[k];
      big_lineBuffer[i] = big_ma[k];
   }
```


