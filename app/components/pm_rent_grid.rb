class PmRentGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.collapsible=true
    c.enable_edit_inline=false
    c.rows_per_page=10
    c.data_store={sorters: [{property: :updated_at, direction: :DESC}]}
    c.model='PmRent'
    c.title ='【XX--配置】'
  end
  def default_columns
    [
 {name: :user_name, text: 'user_name',width:150}, {name: :user_email, text: 'user_email',width:150}, {name: :user_remark, text: 'user_remark',width:150},
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
