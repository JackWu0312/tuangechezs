package com.talkingdata.plugin.appanalytics;

import android.content.Context;

import com.tendcloud.tenddata.Order;
import com.tendcloud.tenddata.ShoppingCart;
import com.tendcloud.tenddata.TCAgent;
import com.tendcloud.tenddata.TDAccount;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** TalkingDataAppAnalyticsPlugin */
public class TalkingDataAppAnalyticsPlugin implements MethodCallHandler {
  private Context context;

  private TalkingDataAppAnalyticsPlugin(Context context){
    this.context = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "TalkingData_AppAnalytics");
    channel.setMethodCallHandler(new TalkingDataAppAnalyticsPlugin(registrar.context().getApplicationContext()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method){
      case "getDeviceID":
        result.success(TCAgent.getDeviceId(context));
        break;
      case "onPageStart":
        TCAgent.onPageStart(context, (String) call.argument("pageName"));
        break;
      case "onPageEnd":
        TCAgent.onPageEnd(context, (String) call.argument("pageName"));
        break;
      case "onEvent":
        String eventID = call.argument("eventID");
        String eventLabel = call.argument("eventLabel");
        Map params = null;
        if (call.argument("params") instanceof Map){
          params = call.argument("params");
        }
        TCAgent.onEvent(context, eventID, eventLabel, params);
        break;
      case "setGlobalKV":
        String globalKey = call.argument("key");
        Object globalValue = call.argument("value");
        TCAgent.setGlobalKV(globalKey, globalValue);
        break;
      case "removeGlobalKV":
        String key = call.argument("key");
        TCAgent.removeGlobalKV(key);
        break;
      case "onRegister":
        String accountID = call.argument("accountID");
        String accountType = call.argument("accountType");
        String name = call.argument("name");
        TCAgent.onRegister(accountID, TDAccount.AccountType.valueOf(accountType), name);
        break;
      case "onLogin":
        accountID = call.argument("accountID");
        accountType = call.argument("accountType");
        name = call.argument("name");
        TCAgent.onLogin(accountID, TDAccount.AccountType.valueOf(accountType), name);
        break;
      case "onPlaceOrder":
        TCAgent.onPlaceOrder(
                (String) call.argument("accountID"),
                getOrderFromFlutter(call)
        );
        break;
      case "onViewShoppingCart":
        ShoppingCart shoppingCart = ShoppingCart.createShoppingCart();
        List<Map> shoppingCartDetails = call.argument("shoppingCartDetails");
        for (int i = 0; i < shoppingCartDetails.size(); i++){
          Map map = shoppingCartDetails.get(i);
          shoppingCart.addItem(
                  (String)map.get("itemID"),
                  (String)map.get("category"),
                  (String)map.get("name"),
                  (int)map.get("unitPrice"),
                  (int)map.get("amount")
          );
        }

        TCAgent.onViewShoppingCart(shoppingCart);
        break;
      case "onAddItemToShoppingCart":
        TCAgent.onAddItemToShoppingCart(
                (String) call.argument("itemID"),
                (String) call.argument("category"),
                (String) call.argument("name"),
                (int) call.argument("unitPrice"),
                (int) call.argument("amount")
        );
        break;
      case "onOrderPaySucc":
        TCAgent.onOrderPaySucc(
                (String) call.argument("accountID"),
                (String) call.argument("payType"),
                getOrderFromFlutter(call)
        );
        break;
      case "onViewItem":
        TCAgent.onViewItem(
                (String) call.argument("itemID"),
                (String) call.argument("category"),
                (String) call.argument("name"),
                (int) call.argument("unitPrice")
        );
        break;
      default:
        result.notImplemented();
        break;
    }
  }


  private Order getOrderFromFlutter(MethodCall call){
    Order order = null;
    try{
      String orderID = call.argument("orderID");
      int totalPrice = call.argument("totalPrice");
      String currencyType = call.argument("currencyType");

      List orderDetails = call.argument("orderDetails");

      order = Order.createOrder(orderID, totalPrice, currencyType);
      for (int i = 0; i < orderDetails.size(); i++){
        Map<String, Object> map = (Map) orderDetails.get(i);
        String id = String.valueOf(map.get("id"));
        String category = String.valueOf(map.get("category"));
        String name = String.valueOf(map.get("name"));
        int unitPrice = (int) map.get("unitPrice");
        int amount = (int) map.get("amount");
        order.addItem(id, category, name, unitPrice, amount);
      }
    }catch (Throwable t){
      t.printStackTrace();
    }

    return order;
  }
}
