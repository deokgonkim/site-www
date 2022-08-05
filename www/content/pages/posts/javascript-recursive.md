---
# Title of your post. If not set, filename will be used.
title: "조직도 JavaScript 실험. recursive function. 연습."
date: 2017-05-08T16:41:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "javascript"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

커뮤니티에 javascript를 사용하여, 조직도를 구현하는 것에 대한 질문이 올라왔다.
그래서, 나는 프로그래밍 연습을 하기 위해서, 한 번 만들어보기로 결심하고, 답변을 올렸다.

<a href="https://okky.kr/article/389606">https://okky.kr/article/389606</a>

올리자마자 다시 봐도, 코드 상에 잘못된 부분은 보이지만, 그런 것들은 나중에 시간날지 고칠지 하고, 우선 코드를 내 블로그에 복사해 놓는다.

```javascript
var depth1 = [];
var depth2 = [];
var depth3 = [];
var depth4 = [];

depth1.push(
    {
        GROUP_ID: 1,
        GROUPNAME: '본사',
	children: []
    },
    {
        GROUP_ID: 2,
        GROUPNAME: '지사',
	children: []
    }
);

depth2.push(
    {
        GROUP_ID: 10,
        GROUP_ID_P: 1,
        GROUPNAME: '기술지원본부',
	children: []
    },
    {
        GROUP_ID: 20,
        GROUP_ID_P: 1,
        GROUPNAME: '연구소',
	children: []
    },
    {
        GROUP_ID: 30,
        GROUP_ID_P: 2,
        GROUPNAME: '영업부',
	children: []
    }
);

console.log(depth1);
console.log("========================================");
console.log(depth2);
console.log("========================================");

/*
var datasource = { children: [] };

for(var i=0; i &lt; depth1.length; i++){
	datasource['children'].push({'name': depth1[i]['GROUPNAME'], 'gid': depth1[i]['GROUP_ID'],'children': []});
	for(var j=0; j &lt; depth2.length; j++){
		if(depth1[i]['GROUP_ID'] == depth2[j]['GROUP_ID_P']){
			datasource['children'][i]['children'].push({'name': depth2[j]['GROUPNAME'], 'gid': depth2[j]['GROUP_ID'], 'children':[]});
			for(var k=0; k &lt; depth3.length; k++){
				if(depth2[j]['GROUP_ID'] == depth3[k]['GROUP_ID_P']){
					for(var l=0; l &lt; datasource['children'][i]['children'].length; l++){
						if(depth2[j]['GROUP_ID'] == datasource['children'][i]['children'][l]['gid']){
							datasource['children'][i]['children'][l]['children'].push({'name': depth3[k]['GROUPNAME'], 'gid': depth3[k]['GROUP_ID'], 'children':[]});
							for(var m=0; m &lt; depth4.length; m++){
								if(depth3[k]['GROUP_ID'] == depth4[m]['GROUP_ID_P']){
									for(var n=0; n &lt; datasource['children'][i]['children'][l]['children'].length; n++){
										if(depth3[k]['GROUP_ID'] == datasource['children'][i]['children'][l]['children'][n]['gid']){
											datasource['children'][i]['children'][l]['children'][n]['children'].push({'name': depth4[m]['GROUPNAME'], 'gid': depth4[m]['GROUP_ID'], 'children':[]});
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

console.log("===== FINAL =====");
console.log(JSON.stringify(datasource));
*/

/**
 * tree에서 gid를 가지는 객체를 반환한다.
 * 못 찾으면 undefined를 반환한다.
 */
function findById(tree, gid) {

	//console.log("========================================");
	//console.log(new Error().stack);
	//console.log("========================================");

	if ( tree['GROUP_ID'] == gid ) {
		return tree;
	} else if ( tree.children.length == 0 ) {
		return undefined;
	} else {
		for ( var i = 0 ; i &lt; tree.children.length ; i ++ ) {
			var found = findById(tree.children[i], gid);
			if ( found !== undefined ) {
				return found;
			}
		}
		return undefined;
	}
}

var ROOT = {
	'GROUP_ID': 0,
	'GROUPNAME': 'ROOT',
	'children': []
}

depth1 = depth1.concat(depth2);
for ( var i = 0 ; i &lt; depth1.length ; i ++ ) {
	if ( depth1[i]['GROUP_ID_P'] === undefined ) {
		ROOT.children.push(depth1[i]);
	} else {
		var parent = findById(ROOT, depth1[i]['GROUP_ID_P']);
		if ( parent !== undefined ) {
			parent.children.push(depth1[i]);
		}
	}
}

console.log("FINAL");

console.log(JSON.stringify(ROOT));
```
