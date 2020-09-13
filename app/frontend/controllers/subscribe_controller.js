import { Controller } from "stimulus"
import Rails from '@rails/ujs'


export default class extends Controller {
  static targets = [ 'email' ]

  add(event) {
    event.preventDefault();
    let email = this.emailTarget.value.trim();
    let data = new FormData();
    data.append("subscribe[email]", email);

    Rails.ajax({
      url: '/api/v1/subscribe',
      type: 'post',
      dataType: 'json',
      data: data,
      
      //用 function 的話,"this"只抓的到response,抓不到這個controller
      //success: function(response) { 
      // arrow function
      success: (response) => {
        switch (response.status){
          case 'ok':
            alert('訂閱成功')
            this.emailTarget.value='';
            break;

          case 'duplicated':
            alert(`${response.email}訂閱過囉~`)
            break;
        }
      },
      error: function(err){
        console.log(err);
      }
    });
  }

}
