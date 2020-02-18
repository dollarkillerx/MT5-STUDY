# MT5-STUDY
MT5 study

MQL 是事件驱动类型的语言   更上层的语言把

### 基础部分
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