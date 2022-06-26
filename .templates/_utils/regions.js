
const BASE_REGIONS = [
    { name: 'global', value: 'global' }
]
const GCE_REGIONS = [

]
const AWS_REGIONS = [
  { name: 'us-east-1', value: 'us-east-1' },
  { name: 'ca-central-1', value: 'ca-central-1' }
]
const AZ_REGIONS = [

]

const cloudHandlerFactory = (cloud='') => {
    let REGIONS = [
        ...BASE_REGIONS
    ]

    switch (cloud.toLowerCase()){
        case 'aws':
            REGIONS.push(...AWS_REGIONS)
            break;
        case 'az':
            REGIONS.push(...AZ_REGIONS)
            break;
        case 'gce':
            REGIONS.push(...GCE_REGIONS)
            break;
    }


    return {
        all: () => REGIONS
    }
}


module.exports = {
    aws: cloudHandlerFactory('aws'),
    az: cloudHandlerFactory('az'),
    gce: cloudHandlerFactory('gce')
}
