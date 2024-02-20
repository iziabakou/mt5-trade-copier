//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintResult(const MqlTradeResult& result)
  {
   Print("ask ", result.ask);
   Print("bid ", result.bid);
   Print("comment ", result.comment);
   Print("deal ", result.deal);
   Print("order ", result.order);
   Print("price ", result.price);
   Print("request_id ", result.request_id);
   Print("retcode ", result.retcode);
   Print("retcode_external ", result.retcode_external);
   Print("volume ", result.volume);
  }
//+------------------------------------------------------------------+
