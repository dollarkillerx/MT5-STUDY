//+------------------------------------------------------------------+
//|                                                  transaction.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, DollarkIller ."
#property link      "https://github.com/dollarkillerx"
// 交易模块

struct transctionOrderData{
      double openPrice; // 开单价格
      double openLots;  // 下单量
      datetime openTime; // 开单时间
      double openTp; // 开单止盈
      double openSl; // 开单止损
};

class Transction 
{
public:
   // 买单 (立即执行)
   // params: 货币,手数,止损,止盈,注释,majic,滑点(小点)
   // result: 订单id
   ulong buy(string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 买单 (立即执行) 防止重复开单
   // result: 订单id
   ulong buyPlus(string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 卖单立即执行
   // params: 货币,手数,止损,止盈,注释,majic,滑点(小点)
   // result: 订单id
   ulong sell(string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 卖单
   ulong sellPlus(string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 平当前货币对所有多单  
   // params: 货币对,滑点
   void closeAllBuyBySymbol(string symbol,int deviation,int majic);

   // 平当前货币对所有空单 
   // params: 货币对,滑点
   void closeAllSellBySymbol(string symbol,int deviation,int majic);
   
   // 平当前货币对所有订单 
   // params: 货币对,滑点
   bool closeAllBySymbol(string symbol,int deviation,int majic);
   
   // 修改止损止盈
   // params: 货币,订单类型,止损,止盈
   void modfiySlTp(string symbol,ENUM_POSITION_TYPE type,double sl,double tp);
   
   // 买入挂单
   // params: 买入价格,货币,手数,止盈,止损,注释,majic,滑点
   ulong buyPending(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 买入挂单 防止重复开单
   ulong buyPendingPlus(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 卖出挂单
   // params: 卖出价格,货币,手数,止盈,止损,注释,majic,滑点
   ulong sellPending(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 卖出挂单 防止重复开单
   ulong sellPendingPlus(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation);
   
   // 删除所有挂单
   void delPending(string symbol);
   
   // 获取订单数量
   int positionGetTotal(string symbol,ENUM_POSITION_TYPE type,int majic);
   
   // 获取全部订单数量
   int positionGetAllTotal(string symbol);
   
   // 交易量更具不同平台进行格式化
   double formatLots(string symbol,double lots);
   
   // 获得最近的订单
   ulong positionGetRecent(string symbol,ENUM_POSITION_TYPE type,int majic,transctionOrderData &data);
   
private:
   // 内部调用 订单平息 
   // parars: 订单list id,滑点,平仓数量 0全部平仓 (注意:非订单id)
   void closePositionByLisrId(int id,int deviation,double volume);
 
};

ulong Transction::buy(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
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
   if (sl != 0) {
      request.sl = request.price - sl * Point(); // 止损
   }
   if (tp != 0) {
      request.tp = request.price + sl * Point(); // 止盈
   }
   
   
   if (OrderSend(request,result)) {
      return result.order;
   }
   
   
   PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
   //--- 操作信息
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   return 0;
}

ulong Transction::sell(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   // OrderSend
   request.action = TRADE_ACTION_DEAL; // 下单类别 市价 
   request.symbol = symbol; // 交易品种
   request.type = ORDER_TYPE_SELL; // 下多单
   request.comment = com;
   request.magic = majic;
   request.volume = lots; // 下单量
   request.deviation = deviation;// 滑点  100 小点 就是 10点
   request.price = SymbolInfoDouble(symbol,SYMBOL_BID); // 设置开单价格
    if (sl != 0) {
      request.sl = request.price + sl * Point(); // 止损
   }
   if (tp != 0) {
      request.tp = request.price - sl * Point(); // 止盈
   }
   
   if (OrderSend(request,result)) {
      return result.order;
   }
   
   
   PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
   //--- 操作信息
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   return 0;
}

void Transction::closeAllBuyBySymbol(string symbol,int deviation,int majic) {
   int total = PositionsTotal(); // 返回次持仓数量
   for (int i=total-1;i>=0;i--) {
      ulong index = PositionGetTicket(i); // 持仓编号
      if (index > 0) { // 选中此订单
         if (majic > 0 ) {
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && PositionGetInteger(POSITION_MAGIC) == majic) { // 检测指定货币对  并且是多单
                 this.closePositionByLisrId(i,deviation,0);
            }
         }else {
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ) { // 检测指定货币对  并且是多单
                 this.closePositionByLisrId(i,deviation,0);
            }
         }
      }
   }
}

void Transction::closeAllSellBySymbol(string symbol,int deviation,int majic) {
   int total = PositionsTotal(); // 返回次持仓数量
   for (int i=total-1;i>=0;i--) {
      ulong index = PositionGetTicket(i); // 持仓编号
      if (index > 0) { // 选中此订单
         if (majic > 0) {
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && PositionGetInteger(POSITION_MAGIC) == majic) { // 检测指定货币对  并且是多单
                 this.closePositionByLisrId(i,deviation,0);
            }
         }else {
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) { // 检测指定货币对  并且是多单
              this.closePositionByLisrId(i,deviation,0);
            }
         }
      }
   }
}

bool Transction::closeAllBySymbol(string symbol,int deviation,int majic) {
   int total = PositionsTotal(); // 返回次持仓数量
   if (total == 0) {
      return true;
   }
   for (int i=total-1;i>=0;i--) {
      ulong index = PositionGetTicket(i); // 持仓编号
      if (index > 0) { // 选中此订单
         if (majic == 0 ) {
                  if (PositionGetString(POSITION_SYMBOL) == symbol) { // 检测指定货币对  并且是多单
                       this.closePositionByLisrId(i,deviation,0);
                  }
         }else {
                  if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_MAGIC) == majic) { // 检测指定货币对  并且是多单
                     this.closePositionByLisrId(i,deviation,0);
                  }
         }

      }
   }
   if (PositionsTotal() == 0) {
      return true;
   }
   return false;
}

void Transction::modfiySlTp(string symbol,ENUM_POSITION_TYPE type,double sl,double tp) {
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

void Transction::delPending(string symbol) {
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

void Transction::closePositionByLisrId(int id,int deviation,double volume) {
   ulong order_id = PositionGetTicket(id); // 获取订单id
   if (order_id > 0) {
     string symbol = PositionGetString(POSITION_SYMBOL);
     MqlTradeRequest request = {0};
     MqlTradeResult result = {0};
     request.action = TRADE_ACTION_DEAL; // 市场价格成交
     request.position = order_id;           //  持仓编号
     if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
        request.price = SymbolInfoDouble(symbol,SYMBOL_BID);
        request.type = ORDER_TYPE_SELL;
     }else {
        request.price = SymbolInfoDouble(symbol,SYMBOL_ASK);
        request.type = ORDER_TYPE_BUY;
     }
     
     if (volume > 0) {
        request.volume = volume; // 全部平仓 
     }else {
        request.volume = PositionGetDouble(POSITION_VOLUME); // 全部平仓    
     }

     request.symbol = symbol;
     request.deviation = deviation;
     
     if (OrderSend(request,result)) {
         return;
     }
     printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
     //--- 操作信息
     printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
}

ulong Transction::buyPending(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   price = NormalizeDouble(price,Digits());
   
   // OrderSend
   request.price = price; // 设置开单价格
   request.action = TRADE_ACTION_PENDING;  
   if (price > SymbolInfoDouble(Symbol(),SYMBOL_ASK)) {
      request.type = ORDER_TYPE_BUY_STOP; // 突破买
   }else {
      request.type = ORDER_TYPE_BUY_LIMIT; // 回踩买
   }
   
   request.symbol = symbol; // 交易品种
   request.comment = com;
   request.tp = tp; // 止盈
   request.magic = majic;
   request.volume = lots; // 下单量
   request.deviation = deviation;// 滑点  100 小点 就是 10点
   if (sl != 0) {
      request.sl = request.price - sl * Point(); // 止损
   }
   if (tp != 0) {
      request.tp = request.price + sl * Point(); // 止盈
   }
   
   
   if (OrderSend(request,result)) {
      return result.order;
   }
   
   
   PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
   //--- 操作信息
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   return 0;
}

ulong Transction::sellPending(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   price = NormalizeDouble(price,Digits());
   
   // OrderSend
   request.price = price; // 设置开单价格
   request.action = TRADE_ACTION_PENDING;  
   if (price > SymbolInfoDouble(Symbol(),SYMBOL_BID)) {
      request.type = ORDER_TYPE_SELL_LIMIT; // 突破买
   }else {
      request.type = ORDER_TYPE_SELL_STOP; // 回踩买
   }
   
   request.symbol = symbol; // 交易品种
   request.comment = com;
   request.tp = tp; // 止盈
   request.magic = majic;
   request.volume = lots; // 下单量
   request.deviation = deviation;// 滑点  100 小点 就是 10点
   if (sl != 0) {
      request.sl = request.price + sl * Point(); // 止损
   }
   if (tp != 0) {
      request.tp = request.price - sl * Point(); // 止盈
   }
   
   
   if (OrderSend(request,result)) {
      return result.order;
   }
   
   
   PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
   //--- 操作信息
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   return 0;
}

ulong Transction::buyPlus(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   int total = PositionsTotal();
   for (int i=total -1;i>=0;i--) {
      ulong id = PositionGetTicket(i);
      if (id > 0) {
         if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && PositionGetString(POSITION_COMMENT) == com && PositionGetInteger(POSITION_MAGIC) == majic ) {
            return id;
         }
      }
   }
   // 如果不存在
   return this.buy(symbol,lots,sl,tp,com,majic,deviation);
}

ulong Transction::sellPlus(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   int total = PositionsTotal();
   for (int i=total-1;i>=0;i--) {
      ulong id = PositionGetTicket(i);
      if (id > 0) {
         if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && PositionGetString(POSITION_COMMENT) == com && PositionGetInteger(POSITION_MAGIC) == majic ) {
            return id;
         }
      }
   }
   return this.sell(symbol,lots,sl,tp,com,majic,deviation);
}

ulong Transction::buyPendingPlus(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   int total = OrdersTotal();
   for (int i=total-1;i>=0;i--) {
      ulong id = OrderGetTicket(i);
      if (id > 0) {
         if (OrderGetString(ORDER_SYMBOL) == symbol && (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP) && OrderGetString(ORDER_COMMENT) == com && OrderGetInteger(ORDER_MAGIC) == majic ) {
            return id;
         }
      }
   }
   return this.buyPending(price,symbol,lots,sl,tp,com,majic,deviation); 
}

ulong Transction::sellPendingPlus(double price,string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
   int total = OrdersTotal();
   for (int i=total-1;i>=0;i--) {
      ulong id = OrderGetTicket(i);
      if (id > 0) {
         if (OrderGetString(ORDER_SYMBOL) == symbol && (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP) && OrderGetString(ORDER_COMMENT) == com && OrderGetInteger(ORDER_MAGIC) == majic ) {
            return id;
         }
      }
   }
   return this.sellPending(price,symbol,lots,sl,tp,com,majic,deviation); 
}  

int Transction::positionGetTotal(string symbol,ENUM_POSITION_TYPE type,int majic) {
   int total = PositionsTotal();
   int number = 0;
   for (int i=total-1;i>=0;i--) {
      if (PositionGetTicket(i) > 0) {
         if (PositionGetInteger(POSITION_TYPE) == type && PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_MAGIC) == majic ) {
            number++;
         }
      }
   }
   return number;
}

int Transction::positionGetAllTotal(string symbol) {
   int total = PositionsTotal();
   int number = 0;
   for (int i=total-1;i>=0;i--) {
      if (PositionGetTicket(i) > 0) {
         if (PositionGetString(POSITION_SYMBOL) == symbol) {
            number++;
         }
      }
   }
   return number;  
}

double Transction::formatLots(string symbol,double lots) {
     double a=0;
     double minilots=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
     double steplots=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
     if(lots<minilots) return(0);
     else
      {
        double a1=MathFloor(lots/minilots)*minilots;
        a=a1+MathFloor((lots-a1)/steplots)*steplots;
      }
     return(a);
}



ulong Transction::positionGetRecent(string symbol,ENUM_POSITION_TYPE type,int majic,transctionOrderData &data) {
   int total = PositionsTotal();
   for (int i=total-1;i>=0;i--) {
      ulong id = PositionGetTicket(i);
      if (id > 0) {
         if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == type) {
            if (majic == 0) {
               data.openLots = PositionGetDouble(POSITION_VOLUME);
               data.openPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
               data.openSl = PositionGetDouble(POSITION_SL);
               data.openTime = datetime(PositionGetInteger(POSITION_TIME));
               data.openTp = PositionGetDouble(POSITION_TP);
               return id;
            }else {
               if (PositionGetInteger(POSITION_MAGIC) == majic) {
                  data.openLots = PositionGetDouble(POSITION_VOLUME);
                  data.openPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
                  data.openSl = PositionGetDouble(POSITION_SL);
                  data.openTime = datetime(PositionGetInteger(POSITION_TIME));
                  data.openTp = PositionGetDouble(POSITION_TP);
                  return id;
               }
            }
         }
      }
   }
   return 0;
}