class PmRentItemPersistence < Netzke::Base
  include Netzke::Basepack::ItemPersistence
  component :pm_rent_grid
  component :pm_rent_form
  def configure(c)
    super
    c.header = false
    c.layout= :border
    c.items = [
        { netzke_component: :pm_rent_grid, region: :center, border: false },
        { netzke_component: :pm_rent_form, region: :south, border: false, split: true }
    ]
  end

  js_configure do |c|
    c.layout = :border
    c.border = false
    c.init_component = <<-JS
      function(){
      this.callParent();
      this.pmGrid = this.getComponent('pm_rent_grid');
      this.pmForm = this.getComponent('pm_rent_form');
      this.pmGrid.on('itemclick', function(view, record){
        this.pmForm.netzkeLoad({id: record.getId()});
      }, this);
       this.pmGrid.on('afterlayout', function() {
      var selModel = this.pmGrid.getSelectionModel();
          selModel.select(0,false);
      console.log("select：",selModel.select);
        if (selModel.getCount() == 1) {
      var recordId = selModel.selected.first().getId();
      console.log("选择ID：",recordId)
      this.pmForm.netzkeLoad({id: recordId});
     }
    }, this);
      }
    JS
  end
end
