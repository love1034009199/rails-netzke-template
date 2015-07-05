class Rails::ComponentHelperGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  
  argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

  check_class_collision

  class_option :migration,  :type => :boolean
  class_option :timestamps, :type => :boolean
  class_option :parent,     :type => :string, :desc => "The parent class for the generated model"
  class_option :indexes,    :type => :boolean, :default => true, :desc => "Add indexes for references and belongs_to columns"


  source_root File.expand_path('../templates', __FILE__)



  def create_form_file
    create_file "app/components/#{file_name}_form.rb", <<-FILE
class #{class_name}Form  < Netzke::Basepack::Form
  def configure(c)
    super
    c.model='#{class_name}'
    c.collapsible=true
    c.title='[XXX配置-配置明细]'
    c.bodyPadding='5 5 0'
    c.fieldDefaults={
        labelAlign: 'top',
        msgTarget: 'side'
    }
    c.defaults={
        border: false,
        xtype: 'panel',
        flex: 1,
        layout: 'anchor'
    }
    c.layout='hbox'
    c.items=[
        {
            anchor: '-5',
            xtype: 'textarea',
            height: 400,
            grow: true,
            hide_label: true,
            name: #{attributes_names.map { |name| ":#{name}" }.join(', ')}
        }
    ]
    c.data_store = {auto_load: false}
  end
  action :apply do |a|
    a.icon = :tick
    a.hidden =true
  end
end
    FILE
  end


  def create_grid_file
    create_file "app/components/#{file_name}_grid.rb", <<-FILE
class #{class_name}Grid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.collapsible=true
    c.enable_edit_inline=false
    c.rows_per_page=10
    c.data_store={sorters: [{property: :updated_at, direction: :DESC}]}
    c.model='#{class_name}'
    c.title ='【XX--配置】'
  end
  def default_columns
    [
 #{attributes_names.map { |an| "{name: :#{an}, text: '#{an}',width:150}" }.join(', ')},
       # {name: :PM_PRODUCT_REQUISITION, text: '需求单号',width:150},
       # {name: :PM_PRODUCT_DETAILS, text: '配置内容',width:450},
       # {name: :PM_PRODUCT_CONFIGURE, text: '配置脚本',width:450},
        {name: :created_at, text: '创建时间',read_only: true,format: 'Y-m-d H:i:s'},
        {name: :updated_at, text: '更新时间',read_only: true,format: 'Y-m-d H:i:s'}
    ]
  end
  component :add_window do |c|
    super(c)
    c.title = '[XX--新增]'
  end
  component :edit_window do |c|
    super(c)
    c.title = '[XX--编辑]'
  end
end
    FILE
  end




  def create_item_persistence_file
    create_file "app/components/#{file_name}_item_persistence.rb", <<-FILE
class #{class_name}ItemPersistence < Netzke::Base
  include Netzke::Basepack::ItemPersistence
  component :#{file_name}_grid
  component :#{file_name}_form
  def configure(c)
    super
    c.header = false
    c.layout= :border
    c.items = [
        { netzke_component: :#{file_name}_grid, region: :center, border: false },
        { netzke_component: :#{file_name}_form, region: :south, border: false, split: true }
    ]
  end

  js_configure do |c|
    c.layout = :border
    c.border = false
    c.init_component = <<-JS
      function(){
      this.callParent();
      this.pmGrid = this.getComponent('#{file_name}_grid');
      this.pmForm = this.getComponent('#{file_name}_form');
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
    FILE
  end


  protected

  # Used by the migration template to determine the parent name of the model
  def parent_class_name
    options[:parent] || "ActiveRecord::Base"
  end



end
