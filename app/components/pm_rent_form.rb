class PmRentForm  < Netzke::Basepack::Form
  def configure(c)
    super
    c.model='PmRent'
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
            name: :user_name
        }
    ]
    c.data_store = {auto_load: false}
  end
  action :apply do |a|
    a.icon = :tick
    a.hidden =true
  end
end
