
const a1 = 'apple'


const a2 = `banana dd dd dd`
const a3 = "banana dd dd dd"
const a4 = 'banana dd dd dd'



function apple(a1: number, a2: number){
	return a1+a2
}



const a22 = [1,2,3,4]



function addVehicleSystemTags(payload: AddTagsRequest): Promise<AddTagsResponse> {
    const tag = this.tag + '/addVehicleSystemTags'
    this.logger.debug({ tag, payload })

    const vehicleIds = extractFromArray(payload.tags, 'vehicleId')
    const vehicles = R.isEmpty(vehicleIds)
      ? []
      : await this.vehicleRepo.find({
          select: ['id', 'tenantId'],
          where: {
            id: In(vehicleIds)
          }
        })
    const vehicleMap = arrayToMap(vehicles, 'id')

    payload.tags.forEach((tag) => {
      if (R.isNotNil(tag.vehicleId)) {
        const vehicle = vehicleMap.get(tag.vehicleId)
        if (R.isNotNil(vehicle)) {
          if (vehicle.tenantId !== tag.tenantId)
            throw new RpcException({
              code: status.INVALID_ARGUMENT,
              message: `tenant id ${vehicle.tenantId} of vehicle id ${vehicle.id} does not match with ${tag.tenantId}`
            })
        } else {
          throw new RpcException({
            code: status.NOT_FOUND,
            message: `vehicle id ${tag.vehicleId} not found`
          })
        }
      }
    })

    let savedTags: VehicleSystemTag[]

    await this.vehicleSystemTagRepo.manager.transaction(async (manager) => {
      const newTags = payload.tags.map((tag) => {
        const newTag = new VehicleSystemTag()
        newTag.tenantId = tag.tenantId
        newTag.vehicleId = tag.vehicleId
        newTag.tagType = tag.tagType as TagType
        newTag.rentFlow = tag.rentFlow as RentFlow
        newTag.enabledAt = utc(tag.enabledAt).toDate()
        newTag.deprecatedAt = R.isNotNil(tag.deprecatedAt) ? utc(tag.deprecatedAt).toDate() : null

        return newTag
      })

      savedTags = await manager.save(newTags)
    })

    return {
      result: 'success',
      data: savedTags.map((tag) => {
        return {
          ...R.omit(['createdAt', 'updatedAt'], tag),
          enabledAt: tag.enabledAt.toISOString(),
          deprecatedAt: R.isNotNil(tag.deprecatedAt) ? tag.deprecatedAt.toISOString() : null
        }
      })
    }
  }
