//+------------------------------------------------------------------+
//|                                                      webtest.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <JAson.mqh>
void OnStart()
  {
//---
   //CJAVal js(NULL,jtUNDEF);
   
   //WebRequest
//   CJAVal jb;
//   jb["name"].Add("DollarKiller");
//   jb["age"].Add("18");
//   string s2 = jb.Serialize();
//   printf(s2);
//   
//   jb.Clear();
//   jb.Deserialize(s2);
//   printf(jb["name"].ToStr());
//   printf(jb["age"].ToStr());

   //test1();
   test2();
  }
//+------------------------------------------------------------------+

void test1() {
   string a[] = {"1", "2", "3"};
   int b[] = {1, 2, 3};
   
   CJAVal js;
   js["a"].Add(a[0]);
   js["a"].Add(a[1]);
   js["a"].Add(a[2]);
        
   js["b"].Add(b[0]);
   js["b"].Add(b[1]);
   js["b"].Add(b[2]);
   
   js["c"][0]=1.1;
   js["c"][1]=2.9;
   js["c"][2]=3.03;
   
   string t=js.Serialize();
   Print(t);   // {"a":["1","2","3"],"b":[1,2,3],"c":[1.10000000,2.90000000,3.03000000]}   
   
   
   js.Clear();
   js.Deserialize(t); 
   Print(js["c"][2].ToStr()); //  3.03000000
}

void test2() {
   CJAVal js;
   js["username"] = "dollarkiller";
   js["password"] = "password";
   
   string t = js.Serialize();
   
   string cookie=NULL,headers; 
   char   post[],result[]; 
   StringToCharArray(t,post,0,StringLen(t));
   int res = WebRequest(
   "POST",
   "http://127.0.0.1:8080/auth",
   cookie,
   500,
   post,
   result,
   headers);
   printf("resp: %d",res);
   
   string c = CharArrayToString(result,0,-1,CP_UTF8);
   printf(c);
   
   js.Clear();
   
   js.Deserialize(c);
   printf(js.Serialize());
   
   printf(js["name"].ToStr());
}

//func main() {
//	app := fiber.New()
//
//	app.Post("/auth", func(ctx *fiber.Ctx) {
//		body := ctx.Fasthttp.Request.Body()
//		fmt.Println(string(body))
//
//		ctx.JSON(map[string]interface{}{
//			"name":"dollarKiller",
//			"age":"12",
//		})
//	})
//
//	app.Get("/auth", func(ctx *fiber.Ctx) {
//		log.Println("收到GET消息")
//	})
//
//	log.Println(app.Listen(8080))
//}