//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintRequest(const MqlTradeRequest& request)
  {
   Print("action ", request.action);
   Print("comment ", request.comment);
   Print("deviation ", request.deviation);
   Print("expiration ", request.expiration);
   Print("magic ", request.magic);
   Print("order ", request.order);
   Print("position ", request.position);
   Print("position_by ", request.position_by);
   Print("price ", request.price);
   Print("sl ", request.sl);
   Print("stoplimit ", request.stoplimit);
   Print("symbol ", request.symbol);
   Print("tp ", request.tp);
   Print("type ", request.type);
   Print("type_filling ", request.type_filling);
   Print("type_time ", request.type_time);
   Print("volume ", request.volume);
  }
//+------------------------------------------------------------------+
