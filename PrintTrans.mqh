void PrintTrans(const MqlTradeTransaction& trans){
   Print("deal ", trans.deal);
   Print("deal_type ", trans.deal_type);
   Print("order ", trans.order);
   Print("order_state ", trans.order_state);
   Print("order_type ", trans.order_type);
   Print("position ", trans.position);
   Print("position_by ", trans.position_by);
   Print("price ", trans.price);
   Print("price_sl ", trans.price_sl);
   Print("price_tp ", trans.price_tp);
   Print("price_trigger ", trans.price_trigger);
   Print("symbol ", trans.symbol);
   Print("time_expiration ", trans.time_expiration);
   Print("time_type ", trans.time_type);
   Print("type ", trans.type);
   Print("volume ", trans.volume);
}