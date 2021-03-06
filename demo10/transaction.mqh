//+------------------------------------------------------------------+
//|                                                  transaction.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, DollarkIller ."
#property link      "https://github.com/dollarkillerx"
// 交易模块
class Transction 
{
public:
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
   
   // 买单立即执行
   // params: 货币,手数,止损,止盈,注释,majic,滑点(小点)
   // result: 订单id
   ulong sell(string symbol,double lots,int sl,int tp,string com,int majic,int deviation) {
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
      request.sl = request.price + sl * Point(); // 止损
      request.tp = request.price - sl * Point(); // 止盈
      
      if (OrderSend(request,result)) {
         return result.order;
      }
      
      
      PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      return 0;
   }
   
   
   // 平当前货币对所有多单  
   // params: 货币对,滑点
   void closeAllBuyBySymbol(string symbol,int deviation) {
      int total = PositionsTotal(); // 返回次持仓数量
      for (int i=total-1;i>=0;i--) {
         ulong index = PositionGetTicket(i); // 持仓编号
         if (index > 0) { // 选中此订单
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) { // 检测指定货币对  并且是多单
                 MqlTradeRequest request = {0};
                 MqlTradeResult result = {0};
                 request.action = TRADE_ACTION_DEAL; // 市场价格成交
                 request.position = index;           //  持仓编号
                 request.type = ORDER_TYPE_SELL;
                 request.volume = PositionGetDouble(POSITION_VOLUME); // 全部平仓 
                 request.symbol = symbol;
                 request.deviation = deviation;
                 request.price = SymbolInfoDouble(symbol,SYMBOL_BID);
                 if (OrderSend(request,result)) {
                     continue;
                 }
                 printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                 //--- 操作信息
                 printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
            }
         }
      }
   }

   // 平当前货币对所有空单 
   // params: 货币对,滑点
   void closeAllSellBySymbol(string symbol,int deviation) {
      int total = PositionsTotal(); // 返回次持仓数量
      for (int i=total-1;i>=0;i--) {
         ulong index = PositionGetTicket(i); // 持仓编号
         if (index > 0) { // 选中此订单
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) { // 检测指定货币对  并且是多单
                 MqlTradeRequest request = {0};
                 MqlTradeResult result = {0};
                 request.action = TRADE_ACTION_DEAL; // 市场价格成交
                 request.position = index;           //  持仓编号
                 request.type = ORDER_TYPE_BUY;
                 request.volume = PositionGetDouble(POSITION_VOLUME); // 全部平仓 
                 request.symbol = symbol;
                 request.deviation = deviation;
                 request.price = SymbolInfoDouble(symbol,SYMBOL_ASK);
                 if (OrderSend(request,result)) {
                     continue;
                 }
                 printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                 //--- 操作信息
                 printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
            }
         }
      }
   }
   
   // 平当前货币对所有订单 
   // params: 货币对,滑点
   bool closeAllBySymbol(string symbol,int deviation) {
      int total = PositionsTotal(); // 返回次持仓数量
      if (total == 0) {
         return true;
      }
      for (int i=total-1;i>=0;i--) {
         ulong index = PositionGetTicket(i); // 持仓编号
         if (index > 0) { // 选中此订单
            if (PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) { // 检测指定货币对  并且是多单
                 MqlTradeRequest request = {0};
                 MqlTradeResult result = {0};
                 request.action = TRADE_ACTION_DEAL; // 市场价格成交
                 request.position = index;           //  持仓编号
                 request.type = ORDER_TYPE_BUY;
                 request.volume = PositionGetDouble(POSITION_VOLUME); // 全部平仓 
                 request.symbol = symbol;
                 request.deviation = deviation;
                 request.price = SymbolInfoDouble(symbol,SYMBOL_ASK);
                 if (OrderSend(request,result)) {
                     continue;
                 }
                 printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                 //--- 操作信息
                 printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
            }else{ // 检测指定货币对  并且是多单
                 MqlTradeRequest request = {0};
                 MqlTradeResult result = {0};
                 request.action = TRADE_ACTION_DEAL; // 市场价格成交
                 request.position = index;           //  持仓编号
                 request.type = ORDER_TYPE_SELL;
                 request.volume = PositionGetDouble(POSITION_VOLUME); // 全部平仓 
                 request.symbol = symbol;
                 request.deviation = deviation;
                 request.price = SymbolInfoDouble(symbol,SYMBOL_BID);
                 if (OrderSend(request,result)) {
                     continue;
                 }
                 printf("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
                 //--- 操作信息
                 printf("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
            }
         }
      }
      if (PositionsTotal() == 0) {
         return true;
      }
      return false;
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
};