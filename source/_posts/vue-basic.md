---
title: Vue 基础部分
date: 2021-10-26 17:37:10
categories: 学习
tags:
  - 笔记
  - 前端
  - Vue
cover: https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/6c8e4c06e7fadeb548154c5577ad66254afcf0db.jpg
---

# Vue 学习 (基础部分)

<br>



## Chapter 0 简介

Vue是一套用于构建用户界面的渐进式 JavaScript 框架。

**特点**

1. 采用组件化模式，提高代码复用率，让代码更好维护。
2. 声明式编码，无需直接操作DOM，提高开发效率。
3. 使用虚拟DOM，优秀的Diff算法，复用DOM节点。
4. 使用了MVVM模式，编码简洁，本身只关注UI。

**前置学习**

1. Ajax
2. Prototype
3. Promise
4. Axios
5. ES6 - ES11
6. 包管理器

**搭建开发环境**

1. 方法1：使用`<script>`标签引入。
2. 方法2：使用`NPM`与`Vue-Cli`搭建。

<br>

## Chpater 1 Vue基本

### 1.1 初识案例

```html
<!DOCTYPE html>
<html lang="zh-cn">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vue Test Page</title>
</head>

<body>
    <!-- 目标容器 -->
    <div id="root">
        <h1>
            <!-- Vue 模板 可以使用任何JS表达式 -->
            Hello {{banner}}!
        </h1>
    </div>

    <script type="text/javascript" src="./js/vue.js"></script>
    <script type="text/javascript">
        // 关闭开发环境提示
        Vue.config.productionTip = false;
		
        // 创建实例 传入配置对象
        new Vue({
            // 指定当前 Vue 实例的服务对象容器
            el: document.querySelector('#root'),
            // 指定数据 供 el 中所指定的元素使用
            // Vue 自动查找到使用模板字符的位置并进行动态双向绑定
            // 一般通过组件形式指定
            data: {
                banner: 'My Vue',
            }
        })
    </script>
</body>

</html>
```

**总结**

1. `Vue`的工作方式是创建一个实例，同时传入一个配置对象指定容器与数据等内容；
2. 原`html`中的内容使用了`Vue`中的模板，`Vue`使用一种解析机制，将原DOM使用虚拟化DOM替换，将模板字符串更改为JS中的指定数据。
3. 其中`Vue`对象与`html`容器的绑定是一对一的关系，任何多对一，多对多的绑定均不会起作用。



### 1.2 模板语法与数据绑定

#### 1.2.1 模板的理解

Vue 中有两大类的模板语法：

1. 插值语法 `{{}}`；

   ```html
   <h1>
       Hello {{banner}}!
   </h1>
   ```

2. 指令 `v-bind` `v-for`等等；

   ```html
   <a :href="url">简写链接</a>
   <a v-bind:href="url">v-bind链接</a>
   ```

   可以通过该语法解析标签内部的绑定内容。



#### 1.2.2 数据绑定

```html
<div id="input-form">
        单向绑定<input type="text" v-bind:value="name" disabled="true"><br/>
        双向绑定<input type="text" v-model:value="name"> <br/>
    </div>
```

```js
new Vue({
         el: document.querySelector('#input-form'),
         data: {
         name: "Input something...",
    },
})
```

这样就可实现单向与双向的数据绑定。

**注意：其中`v-model`标签只能应用在表单类的元素上，固定应用于`value`属性上。**



#### 1.2.3 `el` `data`的指定与原型链分析

先前创建的`Vue`对象使用了原型链的方法

![image-20210911170627577](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210911170627577.png)

创建的对象中所有以`$`开头的方法均为开放使用的API， 其余的内部属性不要使用。

而`Vue`对象通过原型链的方法，将`el`容器绑定在`prototype`中的`$mount`方法中。

所以可以在`Vue`组件创建之后再使用`$mount`来挂载容器。
另外`data`属性需要指定为对象，所以在后续的组件化过程中需要使用构建函数返回对象进行数据的绑定加载。

```js
const v = new Vue({
    data: function() {
        return {
            name:'Evan You',
            address: 'Shanghai',
        }
    }
})
v.$mount('#input-form');
```

注意：普通箭头函数中的`this`指向全局的`Window`对象，建议在`data`指定时使用传统函数定义方法。



#### 1.2.4 MVVM 模型

![image-20210911171728786](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210911171728786.png)

> - M：模型（Model）
> - V：视图（View）
> - VM：视图模型（ViewModel）

其中Vue的VM及其原型对象上的数据都可以被直接访问到。



#### 1.2.5 数据代理

JS中为一个对象动态添加属性的方法为：

```js
let propertyValue = "";
let yourObject = {};
Object.defineProperty(yourObject, objectProperty, {
    value: propertyValue,
    // 属性是否参与枚举与迭代
    enumerable: true,
    // 属性是否可更改
    writable: true,
    // 属性是否可被删除
    configurable: true,
    // 每次访问该属性时 getter 函数就会被调用
    // 从而实现值的动态更新
    get() {
        return propertyValue;
    },
    
    set(value) {
        propertyValue = value;
    }
})
```

通过该方法添加的属性是可以进行高级的属性控制。

Vue通过上述方法进行对象的数据代理。

```js
// obj2 代理了 obj1 的数据
let obj = {
    x: 100,
}

let obj2 = {
    y: 200,
}

Object.defineProperty(obj2, 'x', {
    get() {
        return obj.x;
    },
    set(value) {
        obj.x = value;
    }
})
```

Vue对象是通过定义数据代理的方式，将`getter`和`setter`指向传入的数据对象从而进行处理，可以认为是进行了一层封装，从而使得外部调用时直接使用属性名而非`_data.propertyValue`去调用。



### 1.3 事件处理

#### 1.3.1 事件案例

```html
<div id="event-btn">
    <button v-on:click="showInfo1">提示信息</button>
    <button @click="showInfo2(number, $event)">提示信息</button>
</div>
```

```js
new Vue({
     el: document.querySelector('#event-btn'),
     data: {},
     methods: {
         //该函数中的 this 指代 Vue 对象 后续可能指代组件实例
         //event参数指代鼠标事件
         // html 中调用时参数默认为鼠标事件对象
          showInfo1(event) {
               alert('Vue 对象中的 Methods 绑定');
          },
         // 该函数接受html规定的参数
         showInfo2(number, event) {
             console.log(event);
             console.log(number);
         }
     }
})
```

理论上函数也可以放入参数的`data`中，但是这样会导致没有意义的数据代理与劫持。



#### 1.3.2 事件修饰符

1. `prevent` 阻止默认事件
2. `stop` 阻止事件冒泡
3. `once` 事件只触发一次
4. `capture`  使用事件的捕获模式，在捕获阶段就处理事件
5. `self` 只有`event.target`是当前操作的元素时才触发事件
6. `passive` 事件的默认行为立即执行，无需等待事件回调执行完毕

```html
<!-- 组织a标签的默认事件 -->
<a href="cn.bing.com" @click.prevent="showInfo">HREF</a>
```



#### 1.3.3 键盘事件

```html
<input type="text" @keyup="showInfo">
<input type="text" @keydown="showInfo">
```

对于键盘事件 `Vue`也有一系列别名。

```html
<input type="text" @keyup.enter="showInfo">
```

```js
new Vue({
    el:'#root',
    data:{},
    methods:{
        showInfo(event) {
            console.log(event.target.value);
        }
    }
})
```

![image-20210912113151927](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210912113151927.png)



### 1.4 计算属性

#### 1.4.1 计算属性案例

```html
<div id="#root">
    <input type="text" v-model="firstName"> <br/>
    <input type="text" v-model="lastName"> <br/>
    <span></span>
</div>
```

```js
new Vue({
    el:'#root',
    data: {
        firstName:'张',
        lastName:'三'
    },
    // 计算属性
    computed:{
        fullName:{
            get() {
                return this.firstName + this.lastName;
            },
            // 一般不使用set设置因为结果只用于展示
            set(value) {
                this.firstName = value.split('-')[0];
                this.lastName = value.split('-')[1];
            }
        }
    }
})
```

计算属性不储存在`vm._data`中，而是作为源属性的计算结果直接存储在`vm`对象中。



#### 1.4.2 计算属性特性

其中`get`函数仅在所依赖的数据发生变化时与初次读取调用，并进行结果的缓存，**多次解析时使用缓存结果**。

计算属性底层使用了`Object.defineproperty`方法提供的`getter`与`setter`，内部有缓存机制，效率更高。

若需要计算属性的结果被修改，则需要使用`set`函数响应，且其中要引起源数据的更改才能应用。

另外若只需要读取计算属性，有下列简略形式实现`getter`：

```js
computed:{
    fullName() {
        return this.firstName + this.lastName;
    }
}
```



### 1.5 监视属性

#### 1.5.1 监视案例

```js
const vm = new Vue({
    el:'#root',
    data:{
        isHot: true,
    },
    methods: {
        changeWeather() {
            this.isHot = !this.isHot;
        }
    }
    // 配置监视
    watch:{
        isHot: {
    		// 初始化时即调用
    	    immediate: true,
    		// 监视到isHot变化时即调用
            handler(newValue, oldValue) {
                
            },
        }
    }
})

// 外部配置监视
vm.$watch('isHot', {
    	// 初始化时即调用
    	immediate: true,
    	// 监视到isHot变化时即调用
        handler(newValue, oldValue) {},
})
```

监视的属性必须存在，若写错时不会报错，仅会使参数变为`undifined`。

#### 1.5.2 深度监视

监视数据对象内部的数据源，需要将

```js
// 配置监视
watch:{
    'whether.isHot': {
        // 监视多级对象内部所有成员的变化
        deep:true,
    	// 监视到对象成员isHot变化时即调用
        handler(newValue, oldValue) {
                
        },
    },
}
```

#### 1.5.3 监视的简写

当配置的监视项内仅有处理回调而没有其他配置项时，可以使用如下简写：

```js
watch: {
    isHot() {
        // ...
    }
}
```

#### 1.5.4 `watch`与`computed`的对比

两者在大部分情况下没有明显区别。

但是计算属性中无法开启异步数据更新，需要使用`watch`来实现。

另外，所有不被`Vue`所管理的函数（定时器的回调函数，`AJAX`回调函数等）需要写为箭头函数，这样的`this`指向的才是`vm`或者组件实例对象。**箭头函数没有自己的this值**，箭头函数中所使用的this来自于函数作用域链。



### 1.6 `class`与`style`绑定

#### 1.6.1 `class`绑定

```html
<div id="root">
    <!-- 绑定class样式 数组写法 -->
    <!-- Vue 会自动将两个class属性合并 且支持字符串指定 数组解析 对象指定等等-->
    <div class="basic" v-bind:class="mood" @click="changeMood">
    	{{name}}
	</div>
</div>
```

```js
new Vue({
    el:'#root',
    data:{
        name:'Wayne',
        mood: [],
    },
    methods: {
        changeMood() {
            // 字符串式
            this.mood = 'happy';
            
            // 数组式
            this.mood = ['happy','normal'];
            
            // 对象式
            this.mood = {
                happy: true,
                normal: false,
            };
        }
    }
})
```

#### 1.6.2 `style`绑定

```html
<div id="root">
    <!-- 绑定style样式 -->
    <div class="basic" v-bind:style="styleObj" @click="changeMood">
    	{{name}}
	</div>
</div>
```

```js
new Vue({
    el:'#root',
    data:{
        name:'Wayne',
        mood: [],
        styleObj: {
            fontSize: '40px',
            color: 'red',
        }
    },
})
```



### 1.7 渲染

#### 1.7.1 条件渲染

**控制标签的可见性**

```html
<h2 v-show="true">
    Welcome to Outspace!
</h2>
```

该方法只控制标签的`visibility`。



**控制渲染是否进行**

```html
<h2 v-if="false">
    Welcome to Outspace!
</h2>
<h2 v-else>
    Welcome to Tech World!
</h2>
```

另有`v-else-if`，此外该结构的正确执行必须使用相互关联的`v-if`，不能被其他标签阻隔。

可以使用`template`标签保证不用引入额外的`div`嵌套来使`v-if`正常执行。

```html
<template v-if='n===1'>
	<h2>
	    Welcome to Outspace!
	</h2>
</template>
```

使用`v-if`时，元素可能无法被获取到，而`v-show`一定能获取到。



#### 1.7.2 列表渲染

##### `v-for`案例

```html
<div id="root">
    <ul>
        <!-- index 为遍历的数组索引 key用于唯一区分DOM用以动态更新 -->
        <li v-for="(p, index) in persons" :key="index">
        {{p.id}} - {{p.name}}
        </li>
        <!-- 该方法也可以遍历对象 以键值对形式-->
        <li v-for="(value, keyin) of car" :key='keyin'>
            {{key}} : {{value}}
        </li>
    </ul>
</div>
```

```js
new Vue({
    el: '#root',
    data: {
        persons: [
            {id:'001', name:'张三'},
            {id:'002', name:'李四'},
            {id:'003', name:'王五'},
        ],
        car: {
            name: 'BMW 750',
            color: 'white',
        }
    }
});
```

该方法也可以遍历字符串，也可以遍历指定次数。



##### `:key`的原理

用于为节点更新时的`Diff`算法作为唯一标识符，对比同`key`的标签内容，若同则不进行DOM更新，直接复用，若不同则创建新的虚拟DOM以及真是DOM。

![image-20210912141054846](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210912141054846.png)

![image-20210912141414383](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210912141414383.png)



##### 列表过滤

```html
<div id="root">
    <ul>
        <input type="text" v-model="keyword">
        <li v-for="p in persons" :key="p.id">
        {{p.id}} - {{p.name}}
        </li>
    </ul>
</div>
```

```js
new Vue({
    el:'#root',
    data:{
        persons:[
        	{id:'001', name:'马冬梅',age:19},
        	{id:'002', name:'周冬雨',age:20},
        	{id:'003', name:'周杰伦',age:21},
        	{id:'004', name:'温兆伦',age:22},
    	],
        filterPersons: [],
        keyword,
    }
    // 数据监视实现
    watch: {
    	keyword:{
    		immediate:true,
    		handler(value) {
    			this.filterPersons = this.persons.filter((p) => {
                    return p.name.indexOf(value) !== -1;
                })
			}
		}
	},
    
})
```

也可以使用计算属性的方法，并进行排序：

```js
computed: {
    filterPersons() {
        const arr = this.persons.filter((p)=>{
            return p.name.indexOf(this.keyword) !== -1
        });
        if(this.sortType) {
            arr.sort((p1, p2)=> {
                return this.sortType === 1 ? p2.age - p1.age : p1.age - p2.age;
            })
        }
        return arr;
    }
}
```



#### 1.7.3 Vue检测数据的原理

##### 监测案例

```js
let data = {
    name: 'Wayne',
    address: 'Shanghai',
}

const obs = new Observer(data);
let vm = data = obs;

function Observer(obj) {
    const keys = Object.keys(obj);
    keys.forEach((k)=> {
        Object.defineProperty(this, k, {
            get() {
                return obj[k];
            },
            set(val) {
                obj[k] = val;
                // other additinal actions ...
            }
        })
    })
}
```

该方法通过`Observer`设置了一个对于`data`的代理，且通过连续的赋值使得原`data`指针被指向了`Observer`实例，而又因为`Observer`中又保持着对原`data`的引用，所以`data`没有被销毁回收且只能通过`Observer`被访问到，类似于闭包的原理。其中对于每个非对象，非数组的属性都具有一对`getter`和`setter`，`setter`中又添加了功能逻辑用于监视属性值的改动，一旦改动就重新构建DOM，应用了一种修饰器的思想。

另外，`Vue`中还设置了`vm._data`的数据代理，从而可以直接通过`vm.property`直接访问属性；对`Observer`做了递归处理，能够检测任意嵌套的多层数据改动。

##### `Vue.set()`方法

该方法可以用于后续的动态添加数据属性并设置监听。

```js
Vue.set(vm.person, 'sex', '男');
```

同理又有方法

```js
vm.$set(vm.person, 'sex', '男');
```

但是这**两种方法不允许在`vm`对象与`vm._data`上直接添加属性。**

##### 数组内的监视原理

Vue为数组统一设置了一个`Observer`并仅针对调用数组修改方法的操作予以响应，直接索引无法被检测到。

而Vue托管的数组所调用的方法使用了装饰器，用于更新DOM。

> `push()`
> `pop()`
> `shift()`
> `unshift()`
> `splice()`
> `sort()`
> `reverse()`

##### 数据监视总结

1. `Vue`会监视`data`中所有的数据；
2. 通过`Observer`数据代理与闭包实现数据监视；
3. 对象追加的属性默认不做响应式处理，若需要则使用`Vue.set()`或`vm.$set()`；
4. 通过对数组常用方法的修饰器调用原生方法并添加重新解析模板的函数实现数组中数据的监测；



### 1.8  常用方法技巧

#### 1.8.1 收集表单数据

![image-20210912155026711](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210912155026711.png)



#### 1.8.2 过滤器

配置过滤器可以处理属性数据，仅限`Vue2`。

```html
<h3>
    {{time | timeFormater('YYYY-MM-DD HH:mm:ss')}}
</h3>
```

```js
filter: {
    timeFormater(value, str) {
        return dayjs(value).format(str);
    }
},
```

上述均为局部过滤器，过滤器遵循链式原则。



### 1.9 其他`Vue`指令

#### 1.9.1 `v-text`

向其所在的标签插入文本（整体替换`innerHTML`）；

```html
<div v-text="name"></div>
```



#### 1.9.2 `v-html`

与`v-text`相似，但能够解析数据文本中的`html`元素。

> 注意：该标签可能导致安全性问题，直接解析Javascript代码可能会被XSS攻击。一定要在可信的内容上使用。



#### 1.9.3 `v-vloak`

该标签仅用于标记模板内容以用于在低网速情况下，配合CSS避免用户看到未经渲染的源码页面。

```html
<head>
    <style>
        [v-cloak] {
            display:none;
        }
    </style>
</head>
<body>
    <div id='root'>
        <h2 v-cloak>
            {{name}}
        </h2>
    </div>
    <script type="text/javascript" src="yourCDN"></script>
</body>
```



#### 1.9.4 `v-once`

该指令使得所在节点经过初次动态渲染后，就被视为静态内容从而不再渲染。以后数据的改变不会影响`v-once`所在结构的更新，可用于优化性能。



#### 1.9.5 `v-pre`

该指令使得跳过指定阶段的渲染编译过程，可以优化性能或防止不同框架的冲突。



#### 1.9.6 自定义指令

```html
<div id="root">
    <h2>
        <span v-times="n"></span>
    </h2>
</div>
```

```js
new Vue({
    el:'#root',
    data: {
        n: 1,
    },
    // 自定义指令 函数式
    // 对象形式相比于函数形式 可更精细地控制
    directives: {
        // 第一参数为真实DOM元素 第二元素为指定的Vue数据
        // 该函数在指令与元素成功绑定以及指令所在的模板被重新解析时被调用
        times(element, binding) {
            element.innerText = binding.value * 10;
        }
    }
})

// 对象式
'fbind': {
    // 指令与元素成功绑定时
    bind(element, binding) {},
    // 指令所在元素被插入页面时
    inserted(element, binding) {},
    // 指令所在的模板被重新解析时
    update(element, binding) {},
}
```

注意：上述自定义指令均为局部指令且处理函数中的`this`都指向`Window`。

可以通过`Vue.directive()`添加全局自定义指令。



### 1.10 Vue的生命周期

#### 1.10.1 生命周期简介

生命周期又名生命周期回调函数，生命周期钩子。

Vue在操作执行的关键时刻调用一些特殊名称的函数，这些函数的名称不可更改，但其内容可以自定义。其中的`this`指针指向`vm`或者组件实例对象。

```js
// 该生命周期函数在Vue完成模板解析并把初始的真实DOM元素放入页面后（挂载完毕）调用
mounted() {
    setIntervel(()=> {
        this.opacity -= 0.01;
        if(this.opacity <= 0) 
            this.opacity = 1;
    })
}
```



#### 1.10.2 生命周期流程

<img src="https://v3.cn.vuejs.org/images/lifecycle.svg" alt="实例的生命周期" style="zoom:120%;" />

上图中所有的红色边框的函数即为生命周期函数。

1. `beforeCreate` 初始化前：进行了生命周期、事件的配置但是数据代理还未开始；
2. `created` 初始化：数据监测，数据代理；
3. 上述两步完成后，Vue开始解析模板，生成虚拟DOM，但是还不能显示内容；
4. `beforeMount` 挂载前：页面呈现未经编译的DOM，此时所有DOM操作最终均无效；
5. 此时Vue 将虚拟DOM转换为真实DOM插入页面；
6. `mounted` 挂载：此时呈现Vue编译DOM，到此初始化结束。一般可在此自定义：开启定时器，发送网络请求，订阅小心，绑定自定义事件等初始化操作。
7. 初始化完成后，Vue仅在数据发生改变时进行DOM更新
8. `beforeUpdate` 更新前：此时数据是最新的，但是页面旧。
9. 虚拟DOM在此时进行重新渲染，应用Diff与旧虚拟DOM比较，然后完成页面更新。
10. `updated` 更新完成：数据是新的，页面也更新，保持同步。
11. 当`vm.$destroy` (Vue2) / `app.unmount` （Vue3）被调用时，Vue开始销毁流程。清理与其他实例的连接，解绑其全部指令及其自定义事件监听器（原生不会处理）。
12. `beforeUnmount` 销毁前：此时vm的所有内容都可用，一般可以在此阶段进行：关闭定时器，取消订阅消息，解绑自定义事件等操作，但是不会再进行页面的更新。
13. `unmounted`  完成销毁

<br>



## Chpater 2 组件

### 2.1 组件简介

原生的模式依赖关系混乱，不好维护且代码复用率不高。

组件即实现提供特定功能的代码集合，划分合理能够做到提高代码的复用率，简化项目编码。

组件分为非单位件组件与单文件组件（`.vue`文件）。



### 2.2 非单文件组件

#### 2.2.1 非单文件组件注册示例

```html
<body>
    <div id='root'>
        <!-- 编写组件标签 Vue自动替换 -->
        <school></school>
        <school></school>
        <!-- 两组件相互独立 -->
    </div>
</body>
```



```js
// 通过Vue API 实现组件的创建
const school = Vue.extend({
	// Vue 开发者工具使用name进行展示
    name: 'School',
    // 使用 tempate 组件化 html 代码结构
    template: '<div> </div>',
    // 组件的数据设置需要使用函数返回 可以防止多个组件实例访问到同一个 data 对象造成不可预料的更改
    data: function() {
        return {
            website: 'Outspace',
            date: '2021/9/12',
        }
    }
})

new Vue({
    el:'#root',
    // 局部注册组件
    components: {
        school:school,
    }
})
```



#### 2.2.2 使用注意

全局注册组件

```js
Vue.component('school', school);
```

注意：

1. 组件名称如果使用驼峰式，则该组件只能在脚手架环境中正常工作。多单词写法建议使用全小写字符串形式并用`-`连接。
2. 自闭合标签在非脚手架环境下会导致后续标签无法渲染。



#### 2.2.3 组件嵌套

组件的注册嵌套只需要在父组件中写入`component`注册即可，开发者工具会将层次结构显示出来。

通常在`vm`实例下仅定义`app`组件，其他子组件均注册在`app`下。



#### 2.2.4 `VueComponent`

组件本质是一个`VueComponent`函数，由`Vue.extend`生成。

编写组件标签后，Vue会创建对应的组件实例对象，且每次调用返回全新组件实例。

组件配置中的`data` `methods` `watch` `computed` 中函数的 `this` 均为 `VueComponent` 实例对象。



#### 2.2.5 组件的原型关系

`VueComponent`对象与`Vue`对象非常相似，但是组件是一种可复用的`Vue`实例，其在创建时无法指定作用容器，也不创建实例，知识保存了一个构造函数的指针。

实例的隐式原型对象指向自身创造者的原型对象。

**但是`Vue`使得`VueComponent`的原型对象指向`Vue`原型对象实现原型继承链。**

![image-20210912200021004](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210912200021004.png)

这样使得组件实例对象可以访问到`Vue`原型上的属性、方法。



### 2.3 单文件组件

> 通过 `webpack`或者`vue-cli`将`vue`转译成`js`文件。

```vue
<template>
	<!-- template 标签内为组件的 html -->
	<div class='school'>
        <h2>
            {{schoolName}}
    	</h2>
        <h2>
        	{{address}}    
    	</h2>
        <button @click='showName'></button>
    </div>
</template>

<script>
	// script 内为JS交互代码
    export default {
    	name: 'School',
        data: function() {
            return {
                schoolName: 'Outspace',
                address: 'Shanghai',
            }
        },
        methods:{
            showName() {
                alert(this.schoolName);
            }
        }
    }
</script>

<style>
	/* style 内为组件的样式表 */
    [school] {
        backgroud-color: orange;
    }
</style>
```

在`App.js`内引入所有的二级组件。

```js
import School from './School'
import Student from './Student'

export default {
    name: 'App',
    components: {
        School,
        Student,
    }
}
```

在`main.js`内创建`Vue`实例

```js
// 注意该语句只能在脚手架内使用
import App from './App.vue'

new Vue({
    el:'#root',
    template: '<App></App>',
    components: {
        App,
    },
    data() {
    	
	}
})
```

搭建`HTML`结构

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>单文件组件</title>
    </head>
    <body>
        <div id='root'></div>
        <script type="text/javascript" src="./vue.js"></script>
        <script type="text/javascript" src="main.js"></script>
    </body>
</html>
```

<br>



## Chapter 3 使用`Vue-Cli`

### 3.1 初始化脚手架

安装

```shell
npm install -g @vue/cli
```

创建脚手架

```shell
vue create vuetest
```

开启服务器

```shell
cd ./vuetest
npm run serve
```

开启脚手架后的目录结构

![image-20210913100522762](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210913100522762.png)

修改默认配置

添加`vue.config.js`修改CLI的默认配置项。https://cli.vuejs.org/zh/config/#pages

另外使用

```shell
vue inspect > output.js
```

可以命令脚手架输出其默认配置。



### 3.2 `render`函数

在脚手架创建的`main.js`函数中：

```js
import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
```

存在`render`函数，用以将App组件放入容器中。

而在运行时`Vue`库中，使用`render`函数将原来`template`中的模板创建出来

```js
render(createElement) {
    return createElement(App);
}
```

一般用于开发环境的`Vue`包含完整的核心功能与模板解析器，而生产部署环境没有模板解析器导致无法使用`template`配置。



### 3.3  `ref`属性

`ref`为`Vue`设置的对于原始DOM中元素的标识符（可以替代`id`属性），可以通过`VueComponent`中的`$ref`方法取得。

```vue
<template>
	<h1 v-text="msg" ref="title"></h1>
	<button ref="btn" @click="showDom">
        点我输出 Title
    </button>
</template>
<script>
	export default {
        name: 'App',
        data() {
            return {
                msg:'Welcome!',
            };
        },
        methods: {
            showDom() {
                console.log(this.$refs.title);
            }
        }
    }
</script>
```

**其中`this.$refs`保存所有有`ref`属性的对象，对于普通标签储存DOM元素，对于子组件标签储存其实例对象。该方法可用于组件间通信。**



### 3.4 `props`配置

可以使用子组件的`props`属性声明从外部接收的数据，在父组件内可以直接在组件标签上声明传入的数据。

```html
<School name="Lisa" :age="9*2"></School>
```

```vue
<script>
	export default {
        name: 'School',
        data() {
            return {
                msg:'Welcome!',
            };
        },
        // 简单接收
        props: ['name', 'age'],
        // 限制接收类型、必须项与默认值
        props: {
            'name' : {
                type: String,
                required: true,
            },
            'age' : {
            	type: Number,
                default: 99,
        	},
            'sex' : String,
        }
    }
</script>
```

一般`props`是只读的，若需要进行修改，则需要在子组件的`data`内设置一个副本。**但是`Vue`只检测`props`的地址变化，是一个浅层次监视，所以建议对于`props`传入的对象属性不要进行修改**。

在组件生成时`props`的接受要先于`data`的创建。



### 3.5 `mixin`混入

多组件共享一个部分

```vue
<script>
    import {mix} from '../mixin.js'
	export default {
        name: 'School',
        data() {
            return {
                msg:'Welcome!',
            };
        },
		mixins: [mix],
    }
</script>
```

可以单独定义一个`js`文件，然后在`Vue`组件内进行`mixin`引入从而实现`js`代码的复用。

```js
export const mix = {
    methods: {
        showMsg() {
            alert(this.msg);
        }
    }
}
```

组件与外部混入的数据若发生冲突（生命周期函数接受双方）以组件内的数据为准。

通过`Vue.mixin`全局引入这个混合。



### 3.6 插件

```js
const plugins = {
    // 对于引入的 插件 Vue会自动调用 install
    // 还可以传入其他参数
    install(Vue, ...) {
        // 此处可以统一地进行对Vue的配置与
        // 原型方法的增加等等强大功能
    }
}
```

然后使用

```js
Vue.use(plugins);
```





### 3.7 `scoped`样式

默认`<style>`标签内的样式将会混用。造成CSS混乱。

所以直接添加在标签内直接添加`scoped`即可使得该样式仅用于该组件。



### 3.8 组件化编码流程

1. 实现静态组件：
   抽取组件，使用组件实现静态页面效果；
2. 展示动态数据：数据存储位置，名称；数据保存在哪个组件，确定UUID；
3. 交互：绑定事件监听，组件间通讯



1. 组件化编码：
   - 拆分静态组件：组件按功能点拆分，命名不能与`html`元素冲突；
   - 实现动态组件：考虑数据的存放位置
     - 单组件使用
     - 多组件使用则置于其父组件上
   - 实现 交互：绑定事件监听，实现组件间通讯。
2. `props`适用于：
   - 父组件向子组件通讯；
   - 子组件通过获取到的父组件函数向父组件通讯。
3. `v-model`使用：
   - 不建议对`props`传入的参数使用`v-model`进行绑定修改；



### 3.9 浏览器本地存储

`localStorage`与 `sessionStorage`的应用。可以用键值对在规定的时间内进行持久化操作。

也包括`IndexedDB`以及`WebSQL`。

均属于原生JS操作，但在本地Web应用中可以使用暂存。





### 3.10 组件的自定义事件

#### 3.10.1 绑定

```vue
<template>
	<!-- 为组件绑定自定义事件 -->
	<Student v-on:myevent="demo"></Student>
</template>

<script>
	import Student from './components/Student';
    export default {
        name:'App',
        components: {Student},
        data() {
            return {
                msg:'Hello!',
            };
        },
        methods: {
            // 收到传递事件的参数
            demo(name) {
                console.log('demo was invoked!' + 'And student\'s name is '+ name);
            }
        },
    }
</script>
```

```vue
<template>
	<!-- 绑定内部事件 -->
	<button @click="sendStudentName">
        Send
    </button>
</template>

<script>
	export default {
        name:'Student',
        data() {
            return {
                name: 'Lisa',
            };
        },
        methods: {
            sendStudentName() {
                // 释放事件触发信号
                // 还可以传递额外的参数
                this.$emit('myevent', this.name);
            }
        },
    }
</script>
```

也可以直接在组件实例对象上添加事件：

```html
<Student ref="student"></Student>
```

```js
mounted() {
    this.$refs.student.$on('myevent', this.getStudentName);
}
```

自定义事件也可以使用所有的事件修饰符。



#### 3.10.2 解绑与总结

```js
methods: {
    unbind() {
        // 使用组件实例$off解绑指定自定义事件
        this.$off(['myevent']);
    }
}
```

1. 组件的自定义事件适用于子组件向父组件传递信息；
2. 组件上可以绑定原生DOM事件，使用`native`事件修饰符；
3. 注意绑定自定义事件时，注意回调中`this`的指向。



### 3.11 全局事件总线

全局事件总线可以进行任意组件间的通信，是一种`Vue`的编程模式。

该总线必须对所有组件可见，可以调用对应组件的`$on` `$off` `$emit`等API。

```js
new Vue({
    el:'#app',
    render: h => h(App),
    beforeCreate() {
        // 将自身的指针挂载到 Vue 的原型对象上
        // 这样所有的组件均可见且可调用API
        Vue.prototype.$bus = this;
    }
})
```

只需要在执行回调的组件内全局绑定自定义事件，然后在触发组件内发出`emit`信号，那么借助信号与回调函数的机制就可以实现跨组件的数据传递。

但是这种方法可能会污染`Vue`原型对象的命名空间。

```js
mounted() {
    this.$bus.$on('myevent', (data)=>{
    	console.log(JSON.stringify(data));
	})
}
```

另外需要在`beforeDestroy()`内按时解绑自定义事件以免资源浪费。



### 3.12 消息订阅与发布

使用`pubsub-js`等第三方库。

PubSub 其实很简单，可以利用发布订阅原理自行实现。

- 首先创建 PubSub 类，增加 handlers 变量用于保存事件列表；
- 添加事件时，将监听器加到数组中；
- 删除事件时，移除监听器；
- 触发事件，循环遍历并触发所有的事件。

从实现原理看上，Android中的广播也使用了观察者模式，基于消息的发布/订阅事件模型。因此，从实现的角度来看，Android中的广播将广播的发送者和接受者极大程度上解耦，使得系统能够方便集成，更易扩展。



### 3.13 `nextTick`

组件内如遇到数据更新后需要对DOM元素进行操作，则可使用`nextTick`在DOM更新完毕后再进行指定的回调。

```js
this.$nextTick(function() {
    this.$refs.inputTitle.focus();
})
```



### 3.14 过渡与动画

#### 3.14.1 动画

使用`<transition>`标签包含所需要动画的标签，然后使用CSS3创建动画，但选择器名称有规定：

```html
<!-- 指定name以匹配对应选择器 appear 可以使得载入时就执行动画 -->
<transition name='hello' appear>
	<h1>
        HelloWorld!
    </h1>
</transition>
```

```css
.hello-enter-active{
    animation: helloworld 0.5s linear;
}

.hello-leave-active{
    animation: helloworld 0.5s linear;
}

@keyframes helloworld {
    from{
        transform: translateX(-100%);
    }
    to{
        transform: translateX(0px);
    }
}
```

Vue会自行控制动画播放的时机。



#### 3.14.2 过渡

![image-20210914104838287](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/image-20210914104838287.png)

可以使用`transition-group`标签使得过渡被应用到多个内容中，为各个标签添加唯一的`key`值。

也可以使用第三方库。

下面是`Vue`中动画动作的时机标识。

![Transition Diagram](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/transition.png)

