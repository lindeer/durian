
const model = {avatar_url:"https://s3-gz01.didistatic.com/dchat-gz/cPs9U6UXizhaNq39hIFXti7Rdyz9yKmSexVpJr8Ju0BJ2s3yIu",calander:1621839762857,ddopage:"http://o.didichuxing.com/#/assessment/list",department_info:[{id:"100581",name:"效能平台部"},{id:"107783",name:"信息平台部"},{id:"107792",name:"共享技术部"},{id:"111002",name:"质量效能组"}],dept_id:"111002",display_config:3,email:"test9_dichatv_p@didichuxing.com",emp_num:"test9_dichatv_p",emp_status:1,english_name:"",fullname:"test9",id:"65674",is_follow:false,job:"",last_modified:1608896901000,location:{building:"",city:"北京市",country:"",station:""},manager_fullname:"柯文婷 Tina Ke",manager_mail:"kewenting@didiglobal.com",manager_name:"kewenting",name:"test9_dichatv_p",nickname:"fighting!! 😋",team_id:"1",vchannel_id:"282067682263178",work_status:{emoji:":wfh:",mode:"ACTIVE",status:"HOME_OFFICE",text:"在家办公"}};

function Page(options) {
  class _Page {
    constructor(options) {
      Object.assign(this, options)
    }

    setData(obj) {
      let keys = Object.keys(obj);
      Object.assign(this.data, obj);

      sendMessage('_onDataChanged', JSON.stringify(obj));
    }

    onClick() {
      this.setData({
        text: "在家办公" + count++,
      });
      console.log("avatar_url=",this.data.avatar_url);
    }
  }
  sendMessage('_onPageCreated', JSON.stringify({id: 0}));
  return new _Page(options);
}

model['department'] = model.department_info.map((e) => e.name).join('/');
model['self'] = false;
model['job'] = '工程师';
let page = Page({
  data: model,
  onLoad: function () {
  },
  onClickSend: function() {
    this.setData({
      self: !this.data.self,
    })
  },
  sendMsg: function(params) {
    this.setData({
      code: this.data.code + 1
    })
  }
});
