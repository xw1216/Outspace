---
title: Vue 高级部分
date: 2021-10-26 17:37:24
categories: 学习
tags:
  - 笔记
  - 前端
  - Vue
cover: https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/6c8e4c06e7fadeb548154c5577ad66254afcf0db.jpg
---

# Vue 学习 (高级部分)

<br>



## Chapter 4 Vue中的AJAX

### 4.1 跨域代理

通过在浏览器与跨域的目标服务器之间增加一个代理服务器规避浏览器因跨域引起的安全策略问题。

浏览器与代理服务器在同一域下，所以可以避免跨域问题。经典的代理方法有`vue-cli`配置与`nginx`配置。

```vue
<script>
	import axios from 'axios';
    export default {
        name : 'App',
        methods : {
            getStudents() {
                axios.get('http://localhost:8080/students').then(
                response => {
                    console.log(response.data);
                },
                    error => {
                        console.log(error.message);
                    }
                ) 
            }
        }
    }
</script>
```

```js
// vue.config.js
module.exports = {
    pages: {
        index: {
            entry: 'src/main.js',
        },
    },
    lintOnSave: false,
    // 开启跨域代理服务器（方式一）
    // 直接指向目标服务器 当且仅当8080端口处没有请求的资源时
    // 代理服务器才会转发请求
    devServer: {
        proxy: 'http://localhost:5000',
    },
    
    // 方式二
    devServer: {
        proxy: {
            // 请求前缀路径一
            'prefix' : {
                target: 'http://localhost:5000',
                // 重写路径以免目标服务器无法访问
                pathRewrite: {'^/prefix' : ''},
                // 用于支持 websocket
                ws: true,
                // 改变代理服务器向目标服务器的跨域回应
                // 控制请求头中的 host 值
                changeOrigin: true,
            },
            // 可以配置多台以不同前缀区分的代理转发
            '/foo' : {
                target: '',
            },
        },
    },
}
```

`vue`插件库中`vue-resource`为前官方的AJAX库，低版本`Vue`可以使用。



### 4.2 插槽

插槽可以让父组件往子组件指定位置插入html结构，是一种组件间通信方式。

当在外部组件内需要添加自定义内容时：

```vue
<template>
	<div class="container">
        <Category>
            <img slot="center" src="./image/1.jpg" alt="">
            <a slot="footer" href="cn.bing.com">...</a>
    	</Category>
    </div>
</template>
```

1. 默认插槽与具名插槽

```vue
<template>
	<!-- 设置插槽指定Vue将组件外部传入的自定义内容放置于此 -->
	<slot name="center"></slot>
	<!-- 若外部没有插槽 则会显示slot.innerHTML -->
	<slot name="footer">!!!</slot>
</template>
```

2. `template`写法

```html
<template v-slot:footer></template>
```

3. 作用域插槽
   作用域插槽可以通过标签属性向插槽的外部使用者传递内部数据，是一种控制反转与作用域变化的思想：

```html
<slot :games="games"></slot>
```

```html
<Category title="game">
    <template scope="yourScope">
    <!-- 或者 slot-scop="{games}" -->
    	<ol>
        	<!-- 设置了一个数据域调用从插槽内部传来的数据 -->
        	<li v-for="(g, index) in yourScope.games" :key="index">
        		{{g}}
        	</li>
    	</ol>
    </template>
	
</Category>
```

<br>



## Chapter 5 `Vuex`

### 5.1 简介

`Vuex`是专门实现集中式状态/数据管理的插件，对应用中多个组件的共享状态进行集中式的管理（读/写），也是一种组件通信方式，适用于任意组件间通信。

![vuex](https://vuex.vuejs.org/vuex.png)



### 5.2 使用

#### 5.2.1 引入

```js
// main.js
import store from './store'

 const vm = new Vue( {
     el: '#app',
     render: h => h(App),
     // 引入 Vuex store
     store: store,
     beforeCreate() {
         Vue.prototype.$bus = this;
     }
 })
```



#### 5.2.2 `store`结构编写

```js
// ./vuex/index.js 创建vuex中的store
import Vue form 'vue'
import Vuex from 'vuex'
Vue.use(Vuex);

// 响应组件中的动作 通常action中用于获取其他所需数据
const actions = {
    // 该函数参数自动加入了 store 上下文
    add: function(context, value) {
        context.commit('ADD', value);
    }
}
// 操作数据 不要在此进行异步操作
const mutations = {
    // 自动传入了数据
    ADD: function(state, value) {
        state.sum += value;
    }
}
// 存储数据
const state = {
    sum: 0,
}

export default new Vuex.Store({
    actions, 
    mutations,
    state,
})
```

若共享数据操作中没有网络请求或者其他业务逻辑，可以直接越过`actions`调用`commit`。



#### 5.2.3 调用驱动事件

在需要进行共享数据操作处调用`Vuex`：

```js
methods: {
    increment() {
        this.$store.dispatch('add', this.n);
    }
}
```

此外`Vue`开发者工具可以每个`Vuex`操作进行记录。



### 5.3 `store getters`

相当于在`Vuex`级别上的计算属性

```js
import Vue form 'vue'
import Vuex from 'vuex'
Vue.use(Vuex);

const actions = {
    add: function(context, value) {
        context.commit('ADD', value);
    }
}

const mutations = {
    ADD: function(state, value) {
        state.sum += value;
    }
}

const state = {
    sum: 0,
}

// 相当于关于state的计算属性
const getters = {
    bisSum(state) {
        return state.sum * 10;
    }
}

export default new Vuex.Store({
    actions, 
    mutations,
    state,
    getters,
})
```



### 5.4 `maps`系列优化

#### 5.4.1 `mapState` 与`mapGetters`

其中若需要对`this.$store.state`之类的调用做优化，其中`vuex`已经使用了映射方法做了API优化调用，可以使用如下方式：

```js
import {mapState} from 'veux';

export default {
    name : 'App',
    computed: {
        // 该写法直接将生成的键值对全部拆包放入计算属性中
        ...mapState({
            total: 'sum',
            school: 'school',
        }),
        // 对于同名的state 与 获取函数名 可以直接使用数组
        ...mapState(['sum', 'school']);
    },
}
```

对于`getters`，使用`mapGetters`即可，方法类似。



#### 5.4.2 `mapActions`与`mapMutations`

```vue
<template>
	<button @click="increment(sum)">
        Press
    </button>
</template>

<script>
	methods: {
        ...mapMutations({
            increment: 'INC',
            decrement: 'DEC',
        })
    }
</script>
```

该方法可以生成快捷`commit`方法联系`mutations`，但是需要在`html`内传入需要处理的参数，否则是默认的触发事件。

`mapActions`提供`dispatch`函数的快捷生成，使用方法类似。



### 5.5 多组件共享与模块化

对于`vuex`的`store`可以对各个不同功能的数据域方法进行模块化操作：

```js
const personOptins = {
    // 设置按名称查找模块开启
    namespaced: true,
    actions: {},
    mutations: {},
    state: {},
    getters: {},
}

export default new Vuex.Store({
    modules: {
        // 产生store 的模块化
        'yourModuleName': personOptions,
        // 'other': options
    }
})
```

```js
computed: {
    // 引入时注意指定模块查找名
    // 其他的 map 方法也类似
    ...mapState('yourModuleName',['sum','school']);
}
```

另外`mapGetters` `mapActions` 由于内部的设计结构不同，使用手动方法获取模块化内容时注意使用对应的方式。

<br>



## Chapter 6 路由

### 6.1 简介

`vue-router`是专门用于单应用页面的路由功能。单击页面中的导航不会刷新页面，只会做页面的局部更新，且数据需要进行`AJAX`获取。

而**路由**指一对映射关系，根据请求路径展示对应页面或者匹配的处理函数。



### 6.2 基本路由

引入`router`

```js
import Vue from 'vue';
import App from './App';
import Router from 'vue-router';
import router from './router/index.js';
Vue.use(Router);

new Vue({
    el: '#app',
    render: h => h(App),
    router: router,
})
```

创建路由

```js
// ./router/index.js
import Router from 'vue-router';
import Home from '../components/Home'

const router = new Router({
    routes: [
        {
        	path:'/home',
            component: Home,
    	},
    ],
})
```

配置路径变化

```html
<!-- 靠该标签实现路由的切换 -->
<router-link to="/home">To Home</router-link>

<!-- 指定组建的额呈现位置 -->
<router-view></router-view>
```

注意：

1. 当路由时需要重新渲染加入的组件称为路由组件置于`pages`文件夹中，一般组件仍然放置于`components`。
2. 组件实例上添加了`$route`路由对象与`$router`全局路由器对象。
3. 每次路由切换时，对应路由组件都会被销毁或创建。



### 6.3 多级路由

```js
const router = new Router({
    routes: [
        {
            // 一级路由加 / 
        	path:'/home',
            component: Home,
            children: [
                {
                    path:'news',
                    component: 'News',
                }
            ]
    	},
    ],
})
```

```html
<router-link to="/home/news">To Home</router-link>
```



### 6.4 路由传参

跳转路由并携带`query`参数

```html
<!-- 字符串写法 模板字符串-->
<router-link :to="`/home/message/detail?id=${m.id}&title=${m.title}`">{{m.title}}</router-link>
<!-- 对象写法 -->
<router-link :to="{
                  	path:'/home/massege/detail',
                  	query: {
                  		id: m.id,
                  		title: m.title,
                  	},
                  }">
	{{m.title}}
</router-link>
```

内部接收时使用`$route.query`接收所有参数。



### 6.5 路由细节技术

#### 6.5.1 命名路由

另外对于路由可以进行别名的设置：

```js
const router = new Router({
    routes: [
        {
            name: 'index'
            // 一级路由加 / 
        	path:'/home',
            component: Home,
    	},
    ],
})
```

该方法可以简写路由，在`html`可以直接使用：

```html
<router-link class="list-group-item" active-class="active" :to="{name: 'index'}">Home Page</router-link>
```



#### 6.5.2 路由`params`参数

**路由配置**

```js
const router = new Router({
    routes: [
        {
            name: 'index'
            // 使用 : 设置路由解析 params参数
        	path:'/home/:id/:page',
            component: Home,
    	},
    ],
})
```

传参方法与前文类似：

```html
<!-- 字符串写法 模板字符串-->
<router-link :to="`/home/message/detail/${m.id}/${m.title}`">	{{m.title}}
</router-link>
<!-- 对象写法 此处path必须使用name配置-->
<router-link :to="{
                  	path:'routeName',
                  	params: {
                  		id: m.id,
                  		title: m.title,
                  	},
                  }">
	{{m.title}}
</router-link>
```



#### 6.5.3 路由的`props`配置

```js
const router = new Router({
    routes: [
        {
            name: 'index'
        	path:'/home/:id/:page',
            component: Home,
            // 直接传递对象 该对象中所有键值对均以props参数传给Home组件
            props: {},
        	// 设置开关 若开则将params参数注入到组件props属性中
        	props: true,
        	// 设置函数
        	props($route) {
    			return {id:$route.query.id, title:$route.query.title};
			}
    	},
    ],
})
```



#### 6.5.4 `router-link`的`replace`方法

在浏览器的历史记录中`Vue`默认开启了`push`记录模式，即每一次地址变动都会被记录。

`replace`方法即在跳转时，清除当前栈顶的历史项。

```html
<router-link replace :to="`/home/message/detail/${m.id}/${m.title}`">	{{m.title}}
</router-link>
```



#### 6.5.5 缓存路由组件

```html
<!-- 使得内部指定的组件名在路由改变后保持不被销毁 -->
<keep-alive :include="['News','Home']">
	<router-view></router-view>
</keep-alive>
```



#### 6.5.6 生命周期钩子补充

**`activated` 与 `deactivated`两个生命周期**钩子用于 `keep-alive`的组件在路由改变后调用，捕获路由组件的激活状态。



### 6.6 编程式路由导航

不适用`<router-link>`，实现导航与历史记录操作。

```html
<button @click="pushShow(m)">
    Press
</button>
```

```js
methods: {
    pushShow(m) {
        // 使用全局的路由器对象 调用全局方法跳转
        this.$router.push({
            name: 'hello',
            query: {
                id: m.id,
                title: m.title,
            }
        })
    },
    back() {
        this.$router.back();
    },
    forward() {
        this.$router.forward();
    }
    // 还有 $router.go 能够根据传入的数字决定历史记录前进后退几步
}
```



### 6.7 路由守卫

相当于后端的拦截器权限管理，主要用于根据后端的返回信息动态决定页面的加载。

#### 6.7.1 全局前置与后置

```js
// 在每次路由切换前调用回调
// 参数为跳转前路由与跳转后路由
router.beforeEach((to, from, next) => {
    if(to.meta.isAuth) {
       // 符合条件则调用next放行
        if(localStorage.getItem('school') === '') {
            next();
        }
    } 
})
```

在`$route`内有`meta`对象属性，用于放置自定义内容，可以在内部确定如页面是否需要权限才能查看。

```js
router.beforeEach((to, from) => {
    // 通常在此进行完成页面切换的初始化工作
    document.title = "新标签页";
}
```



#### 6.7.2 独享守卫

直接在路由配置处配置`beforeEnter`，注意独享路由守卫只有前置。

```js
const router = new Router({
    routes: [
        {
            name: 'index'
        	path:'/home/:id/:page',
            component: Home,
        	props($route) {
    			return {id:$route.query.id, title:$route.query.title};
			},
    		// 直接在router内配置
    		beforeEnter(to, from, next) {
                // .......
            }
    	},
    ],
})
```



#### 6.7.3 组件内路由守卫

```js
export default {
    name: 'about',
    // 通过路由规则进入该组件时被调用
    beforeRouteEnter (to, from, next) {
        // ...
    },
    // 通过路由规则离开该组件时被调用
    beforeRouteLeave (to, from, next) {
        // ... 
    }
}
```



### 6.8 路由工作模式

1. `hash`工作模式
   - 路径中有`#`号，且后续的路径内容不会发送给服务器
   - 兼容性好
   - 部署时不会造成404问题
   - 路径可能会造成APP分享时地址检验不合法
2. `history`工作模式
   - 路径中无`#`号
   - 兼容性略差
   - 部署时需要根据路由路径配置刷新资源不存在问题
     - nginx
     - nodejs 后端适配
     - java 类库

```js
const router = new Router({
    // 在 mode 模式中配置
    mode: 'history',
    routes: [],
})
```

<br>



## Chapter 7 Vue UI 组件库

### 7.1 UI库介绍

- 移动端
  - Vant
  - Cube UI
  - Mint UI
- PC端
  - Element UI
  - IView UI
  - Ant Design

一般UI库均可以按需引入。

<br>



## Chpater 8  `Vue3` 特性

### 8.1 简介

新的`Vue3`内容可以使用`Vue-CLI`与`Vite`官方构建工具创建。

使用了`Proxy`代替`defineProperty`实现更好的响应式，以及重写了虚拟DOM实现，新增了`Tree-Shaking`，更好支持`TypeScript`。

`vue-cli`新工程的创建：

```shell
vue create vue_test
cd vue_test
npm run serve
```

`vite`创建：

其是官方提供的前端构建工具，开发环境中无需重新打包，快速冷启动，热重载，按需编译。

```shell
npm init vite-app
cd <project-name>
npm install
npm run dev
```



### 8.2 `Vue3`工程分析

首先不再引入Vue构造函数，而是新的封装函数。

```js
import { createApp } from 'vue'
import App from './App.vue'

// 创建应用实例对象app 类似于vm但是少了一部分成员
createApp(App).mount('#app');

// 对比 Vue 2 方式
const vm = new Vue({
    render: (h) => {
        h(App);
    }
})
vm.$mount('#app');
```

此外`vue`文件中的模板结构可以没有根标签`<div>`包裹。



### 8.3 常用组合式`Composition API`

#### 8.3.1 `Setup`

- 是一个新的配置项，值为函数。
- 所有的数据方法均配置在`Setup`函数中。
- 可以有两种返回值：
  - 若返回对象，则对象中的属性、方法、内容均可在模板中直接使用；
  - 若返回一个渲染函数，则可以直接自定义渲染内容。（将覆盖所有的`<template>`模板内容）

```vue
<script>
	import {h} from 'vue';
    export default {
        name: 'App',
        setup() {
            let name = "Alan";
            let age = 20;
            
            function sayHello() {
                console.log(`Hi, I'm ${name}, ${age}, how are you?`);
            }
            
            return {
                name,
                age,
                sayHello,
            }
            
            // 或者返回自定义渲染函数
            return () => h('h1', 'Outspace');
        },
        
        // vue的配置方式也可以使用
        // 但是这样定义的内容 Vue3 无法调用
        data() {
            return {
                gender: 'male',
            }
        },
        methods: {
            sayHi() {},
        }
    }

</script>
```

注意：

- 不要两种版本混用；
- 有重名内容时，`Vue3`中的`Setup`内容由于后生成所以会覆盖，加入到`_data`中；
- `Setup`不能为`async`异步，因为模板无法解析返回值的`promise`对象。（`Vue3`新版本已经解决）

#### 8.3.2 `ref`函数

```js
import {ref} from 'vue';
// 直接调用 ref 传入内容 指定一个响应式对象
// ref 将对数据进行加工装箱
let age = ref(18);
```

其通过模板与`defineProperty`进行原型上的数据代理，使用了`RefImpl`实例对象包装，当需要响应式时：

```js
age.value = 19;
```

这样就能够触发`getter`，`setter`从而实现响应式。但是在`<template>`模板中直接使用变量名就可以实现值的引用。

```html
<h2>
    {{age}}
</h2>
```

但是对于**传入对象**的`ref`函数，其将该对象包装为`Proxy`，实际上调用了`reactive`新内部函数进行数据加工。实际上完成了对于基本类型与对象的接口统一。

`proxy`是新的ES标准中规定的访问拦截器，其将数据包装为可以调用特定`handler`方法的包装对象，根据代码运行时动作自动调用`handler`内部的相应自定义方法。



#### 8.3.3 `reative`函数

该函数可以定义一个数组，对象类型的响应式数据（无法处理基本类型），并且可以嵌套响应式。

```js
let person = reactive({
    name: 'Wayne',
    age: '20',
    job: {
        type: 'Student',
        subject: 'CS',
    },
});
```

返回`Proxy`的实例对象。数组可以直接通过下标处理数据，同样能够实现响应式。



#### 8.3.4 `Vue3`响应式原理

`Vue2`对比：通过`Object.defineProperty`进行递归的数据劫持，对数组重写常用方法，并且在总的`Vue`实例中添加了全局的`$set`，`$delete`函数，从而实现了响应式。

而在`Vue3`中，响应式的原理直接通过ES新规范中的`Proxy`进行包装。

- 通过`Proxy`直接从语言层面拦截`Proxy`对象中的任意变化，包括属性值的增删改查等。
- 通过`Reflect`对被代理对象的属性进行操作。

```js
let person = {
    name: 'wayne',
    age: 20,
}

// 以下均为
const p = new Proxy(person, {
    // 函数直接得到源对象与被访问的属性名
    // 查
    get(target, propName) {
        // do something....
        return target[propName];
    },
    // 增 改
    set(target, propName, value) {
        // rerender the page
        target[propName] = value;
    },
    // 删
    deleteProperty(target, propName) {
        // do something 
        return delete target[propName];
    }
})
```

另外可以通过ES6新增的类似Java 的反射机制进行，属性的更改：

```js
Reflect.set(target, propName, value);
```

这样能够避免原实现中可能造成的抛出异常，重载等问题。



#### 8.3.5 `Setup`注意

- `Setup`会在`beforeCreate`生命周期函数前执行，且`this`为`undefined`；
- `Setup`内部无法通过`this`获取数据，所以`props`参数与`context`由框架从外部传入
  - `props`值为对象，包含组件外传入且内部声明接受了的属性；
  - `context`上下文含：
    - `attrs`为对象，包含组件外传入但未接受的属性；
    - `slot`收到的插槽内容，含虚拟DOM；
    - `emit`分发自定义事件的函数。

```js
export default {
    name: 'demo',
    props: ['msg'],
    emits: ['hello'],
    setup(props, context) {
        function btnClick() {
            context.emit('hello', msg);
        }
        
        console.log(props, context.attrs, context.emit, context.slots);
        return {btnClick};
    }
}
```

```vue
<template>
	<demo @hello='showMsg' msg="HelloComponent">
        <template v-slot:logo>
    		<span>Outspace</span>
		</template>
    </demo>
</template>

<script>
	import demo from './components/demo';
    export default {
        name: 'App',
        components: {demo},
        setup() {
            function showMsg(value){
                alert(value);
            }
            
            
            return {
                showMsg,
            };
        }
    }
</script>
```



#### 8.3.6 计算属性与监视

**计算属性**

仍可以使用`vue2`计算属性的风格，但是可以按需在`Setup`内引入`computed`函数实现计算属性。

```js
// 只读简写
person.fullName = computed(()=>{
    return person.firstName + '-' + person.lastName;
})

// 读写
person.fullName = computed({
    get() {
        // do something 
    },
    set(value) {
        // do something
    }
})
```

**监视**

```js
setup() {
    let sum = ref(0);
    let msg = reactive({msg : 'hello',});
    // 单个监视
    watch(sum, (newVal, oldVal) => {
        // do something...
    });
    
    // 多个监视
    watch([sum, msg], 
          (newVal, oldVal) => {
        	// 多个监视参数时
        	// 传入的值也为数组
    	  }, 
          // 还可以传入配置
          {immediate: true, deep: true},
    );
}
```

注意，目前的`watch`函数对于`reactive`创建的响应式数据，仍有`bug`：

- 传入的`oldValue`是无法正确获取的，原因为新旧数据均指向同一对象。

- 深度监视是无法关闭的（`Proxy`机制仍会响应）。

- 监视响应式对象内部的某一些内容，需要：

  ```js
  watch([()=>person.name, ()=>person.age], (newVal, oldVal)=> {
      console.log();
  })
  ```

  且对于对象的内部数据，需要开启`deep`深度监视属性。因为`Proxy`机制实际上只在对象顶层进行处理。

对于`ref`定义的对象，若需要深度监视，仍需要开启`deep`。

**`watchEffect`函数**

该函数可以实现，在回调中使用了哪个属性，就监视哪个属性，但是不需要像计算属性一样写函数的返回值。

只要内部使用的某属性变化，整个`watchEffect`函数都会重新调用。

```js
watchEffect(()=> {
    const x1 = sum.value;
    const x2 = person.name;
    console.log(x1, x2);
})
```



#### 8.3.7 生命周期

<img src="https://vue3js.cn/docs/zh/images/lifecycle.png" alt="实例的生命周期" style="zoom: 50%;" />

所有的生命周期钩子可以使用`vue2`风格使用，也可以通过组合式API使用。

- `beforeCreate`与`created`两个函数对应`setup`；
- 所有其他的钩子在组合式时在函数前加`On`。
- 组合式钩子加载早于函数式。



#### 8.3.8 自定义`Hook`函数

其本质是函数，将`setup`中的组合式API进行封装，类似于`mixin`混入，可以复用代码，让`setup`中的逻辑更清晰。

```js
// ../hooks/useHook.js
import {reactive, onMounted, onBeforeMounted} from 'vue'
export default function () {
    // do something
    return point;
}
```

```vue
<script>
	import useHook from '../hooks/usePoint';
    export default {
        name: 'Test',
        setup() {
            point = usePoint();
        }
    }
</script>
```

这样实际上就是一种代码逻辑的拆分方法，并且能够快捷得调用。



#### 8.3.9 `toRefs`

该函数可以将某响应式对象中的属性单独作为响应式变量提供外部使用时调用。

```js
const reactiveMember = toRef(reactiveObj, 'attributeStr');

// 多个直接指定响应式对象本身
// 其内部所有成员将被包装为响应式
toRefs(reactiveObj)
```

该函数的产生原因为：由于`Vue3`对于对象的响应式实现方法`proxy`只在被处理对象层做出响应而非成员，所以当仅需要暴露对象成员时，使用`toRefs`实现（而非手动重写`proxy`的`getter`与`setter`）。

其中`reactiveMember`已经被包装为`ObjectRefImpl`类，并进行数据代理，直接对原`reactiveObj`进行修改操作，是一种引用的响应式实现。



### 8.4 其他的组合式API

#### 8.4.1 浅层次响应式对象

- `shallowReative`，该函数指定对于一个嵌套层次较深的对象类型，只检测对象最外层属性的变化。
- `shallowRef`，该函数指定只处理基本类型的响应式，也可用于对象整体的替换监测。



#### 8.4.2 只读

- `readonly` 使嵌套的响应式数据全部只读；
- `shallowReadonly` 使一个响应式数据变为浅层只读；

适用于不得对数据进行更改时。



#### 8.4.3 `toRaw`与`markRaw`

上述两个API可以使对象由响应式变为普通数据，以及标记该对象永不成为响应式数据。

`toRaw`可以读取响应式对象对应的普通对象，对这个普通对象的所有操作不会引起页面更新。

`markRaw`由于某些第三方类库或者有不可变数据源的大列表不宜成为响应式对象，所以可以标记其不能成为响应式。



#### 8.4.4 `customRef` 

创建一个自定义的`ref`，并对其依赖项跟踪和更新触发进行显式控制。

```vue
<template>
	<input type="text" v-model="keyword">
	<h3>
        {{keyword}}
    </h3>
</template>

<script>
	import {ref, customRef} from 'vue';
    export default {
        name: 'App',
        setup() {
            function myRef(value, delay) {
                let timer;
                // 相当于写 proxy 的 handle 处理函数
                // 用于覆盖框架默认的 ref 行为
                const myRef = customRef((track, trigger) => {
                    get() {
                        // 追踪数据变化而非忽略
                        track();
                        return value;
                    },
                    set(newVal) {
                        clearTimeout(timer);
                        // 定时器用于防抖
                        timer = setTimeout(()=> {
                            value = newVal;
                        // 使Vue重新解析模板
                        	trigger();
                        }, delay);
                    },
                });
            };
            
            let keyword = myRef('hello', 500);
            return {keyword};
        }
    }

</script>
```



#### 8.4.5 `provide`与`inject`

上述API可实现祖先后代（跨级）间组件通信，父组件使用`provide`提供数据，子组件使用`inject`使用数据。

使用如下简单API，即可跨级传递响应式对象：

```js
provide('car', car); // 标明传输名与对象名

inject('car'); // 直接使用传输名获取对象
```



#### 8.4.6 响应式API的判断

- `isRef`
- `isReactive`
- `isReadOnly`
- `isProxy`

分别用于检查对象是否具有上述属性。需要注意的是`readonly`方法创建的对象也属于`proxy`类别。



### 8.5 组合式API的优势

- 首先原`options`API中会导致各个方法的耦合在同一的`options`中。
- 组合式API可以将同一个功能中的实现全部组合到同一的`hook`中，同时可以按需引入。



### 8.6 新组件特性

#### 8.6.1 `Fragment`

`Vue3`中组件可以没有根标签，内部会将多个标签包含在同一个`Fragment`虚拟元素中，最后不参与渲染。



#### 8.6.2 `Teleport`

该方法能够直接将组件的`html`内容直接移动到指定的位置，如述内容在渲染完成后将直接挂载到`body`标签而非父组件上。

```vue
<template>
	<!-- 此处可以直接使用CSS选择器 -->
	<teleport to="body">
    	<div v-if="isShow" class="dialog">
            <button @click="isShow = false00">
				关闭                
    		</button>
    	</div>
    </teleport>
</template>
```



#### 8.6.3 `Suspense`

```js
import {defineAsyncComponent} from 'vue';
// 异步引入组件 可以避免主组件对所有子组件的载入等待
const Child = defineAsyncComponent(()=>import('./components/Child'));
```

```vue
<template>
	<Suspense>
    	<template v-slot:default>
			<Child/>
		</template>
		<template v-slot:fallback>
			<h3>
                加载中...
            </h3>
		</template>
    </Suspense>
</template>
```

提供了动态等待异步引入的方法，且组件`setup`使用`async await`返回值可以为`promise`了。



### 8.7 其他新特性

- 全局API转移；
  原部分`Vue`内的配置项没有完全移动到组合式的API中。
  且原来向`Vue.prototype`中添加内容实现跨组件通讯的方式被转移到`app.config.globalProperties`中。
- `Vue3`中`data`应当一直被写为函数
- 移除`keyCode`键盘编码作为事件触发以及移除`v-on.native`；
- 移除过滤器。
