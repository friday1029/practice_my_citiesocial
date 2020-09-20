import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = [ "quantity", "addToCartButton", "sku" ]


  addToCart(evt){
    evt.preventDefault(); 
    let product_id = this.data.get("id");
    let quantity = Number(this.quantityTarget.value);
    let sku = this.skuTarget.value;
    if ( quantity > 0 ){
      this.addToCartButtonTarget.classList.add("is-loading");
    }
    let data = new FormData();
    data.append("id", product_id);
    data.append("quantity", quantity);
    data.append("sku", sku);
    
    Rails.ajax({
      url: "/api/v1/cart",
      data,
      type: "post",
      success: resp => {
        if (resp.status === 'ok'){
          let item_count = resp.items || 0 ;
          //發 event
          let evt = new CustomEvent('addToCartEvent', { 'detail': { item_count: item_count } });
          document.dispatchEvent(evt); //拋出事件
        }
        console.log( resp );
      },
      error: err=> {
        console.log(err);
      },
      complete: () => {
        this.addToCartButtonTarget.classList.remove("is-loading");
      }
    });
  }

  quantity_minus(evt){
    evt.preventDefault();
    let q = Number(this.quantityTarget.value);
    if ( q > 1 ){
      this.quantityTarget.value = q - 1 ;
    }
  }
  quantity_plus(evt){
    evt.preventDefault();
    let q = Number(this.quantityTarget.value);
    this.quantityTarget.value = q + 1 ;
  }
}
