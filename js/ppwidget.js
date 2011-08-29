function displayVals() {
  var t3 = $("#t3").val();
  var amount = $("#amount").val();
  if(t3 != 0){
    $('#a3').val(amount);
    $('#p3').val(1);
    $('#cmd').val('_xclick-subscriptions');
    $('#item_name').val('Tor Project Membership');
    $('#ppinfo').replaceWith('<h6 id="ppinfo"><small>(Requires a PayPal Account)</small></h6>');
  }else{
    $('#a3').val(0);
    $('#p3').val(0);
    $('#cmd').val('_donations');
    $('#item_name').val('Donation to the Tor Project');
    $('#ppinfo').replaceWith('<h6 id="ppinfo" style="height:0px;"></h6>');
  }
  if( !t3 ) {
    $('#cmd').val('_donations');
    $('#item_name').val('Donation to the Tor Project');
    $('#ppinfo').replaceWith('<h6 id="ppinfo" style="height:0px;"></h6>');
  }
}
$(function(){
  $("#amount").change(displayVals);
  $("#t3").change(displayVals);
  displayVals();
});
