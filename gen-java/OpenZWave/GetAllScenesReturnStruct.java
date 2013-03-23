/**
 * Autogenerated by Thrift Compiler (1.0.0-dev)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
package OpenZWave;

import org.apache.thrift.scheme.IScheme;
import org.apache.thrift.scheme.SchemeFactory;
import org.apache.thrift.scheme.StandardScheme;

import org.apache.thrift.scheme.TupleScheme;
import org.apache.thrift.protocol.TTupleProtocol;
import org.apache.thrift.protocol.TProtocolException;
import org.apache.thrift.EncodingUtils;
import org.apache.thrift.TException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.EnumMap;
import java.util.Set;
import java.util.HashSet;
import java.util.EnumSet;
import java.util.Collections;
import java.util.BitSet;
import java.nio.ByteBuffer;
import java.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GetAllScenesReturnStruct implements org.apache.thrift.TBase<GetAllScenesReturnStruct, GetAllScenesReturnStruct._Fields>, java.io.Serializable, Cloneable, Comparable<GetAllScenesReturnStruct> {
  private static final org.apache.thrift.protocol.TStruct STRUCT_DESC = new org.apache.thrift.protocol.TStruct("GetAllScenesReturnStruct");

  private static final org.apache.thrift.protocol.TField RETVAL_FIELD_DESC = new org.apache.thrift.protocol.TField("retval", org.apache.thrift.protocol.TType.BYTE, (short)1);
  private static final org.apache.thrift.protocol.TField _SCENE_IDS_FIELD_DESC = new org.apache.thrift.protocol.TField("_sceneIds", org.apache.thrift.protocol.TType.LIST, (short)2);

  private static final Map<Class<? extends IScheme>, SchemeFactory> schemes = new HashMap<Class<? extends IScheme>, SchemeFactory>();
  static {
    schemes.put(StandardScheme.class, new GetAllScenesReturnStructStandardSchemeFactory());
    schemes.put(TupleScheme.class, new GetAllScenesReturnStructTupleSchemeFactory());
  }

  public byte retval; // required
  public List<Byte> _sceneIds; // required

  /** The set of fields this struct contains, along with convenience methods for finding and manipulating them. */
  public enum _Fields implements org.apache.thrift.TFieldIdEnum {
    RETVAL((short)1, "retval"),
    _SCENE_IDS((short)2, "_sceneIds");

    private static final Map<String, _Fields> byName = new HashMap<String, _Fields>();

    static {
      for (_Fields field : EnumSet.allOf(_Fields.class)) {
        byName.put(field.getFieldName(), field);
      }
    }

    /**
     * Find the _Fields constant that matches fieldId, or null if its not found.
     */
    public static _Fields findByThriftId(int fieldId) {
      switch(fieldId) {
        case 1: // RETVAL
          return RETVAL;
        case 2: // _SCENE_IDS
          return _SCENE_IDS;
        default:
          return null;
      }
    }

    /**
     * Find the _Fields constant that matches fieldId, throwing an exception
     * if it is not found.
     */
    public static _Fields findByThriftIdOrThrow(int fieldId) {
      _Fields fields = findByThriftId(fieldId);
      if (fields == null) throw new IllegalArgumentException("Field " + fieldId + " doesn't exist!");
      return fields;
    }

    /**
     * Find the _Fields constant that matches name, or null if its not found.
     */
    public static _Fields findByName(String name) {
      return byName.get(name);
    }

    private final short _thriftId;
    private final String _fieldName;

    _Fields(short thriftId, String fieldName) {
      _thriftId = thriftId;
      _fieldName = fieldName;
    }

    public short getThriftFieldId() {
      return _thriftId;
    }

    public String getFieldName() {
      return _fieldName;
    }
  }

  // isset id assignments
  private static final int __RETVAL_ISSET_ID = 0;
  private byte __isset_bitfield = 0;
  public static final Map<_Fields, org.apache.thrift.meta_data.FieldMetaData> metaDataMap;
  static {
    Map<_Fields, org.apache.thrift.meta_data.FieldMetaData> tmpMap = new EnumMap<_Fields, org.apache.thrift.meta_data.FieldMetaData>(_Fields.class);
    tmpMap.put(_Fields.RETVAL, new org.apache.thrift.meta_data.FieldMetaData("retval", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.BYTE)));
    tmpMap.put(_Fields._SCENE_IDS, new org.apache.thrift.meta_data.FieldMetaData("_sceneIds", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.ListMetaData(org.apache.thrift.protocol.TType.LIST, 
            new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.BYTE))));
    metaDataMap = Collections.unmodifiableMap(tmpMap);
    org.apache.thrift.meta_data.FieldMetaData.addStructMetaDataMap(GetAllScenesReturnStruct.class, metaDataMap);
  }

  public GetAllScenesReturnStruct() {
  }

  public GetAllScenesReturnStruct(
    byte retval,
    List<Byte> _sceneIds)
  {
    this();
    this.retval = retval;
    setRetvalIsSet(true);
    this._sceneIds = _sceneIds;
  }

  /**
   * Performs a deep copy on <i>other</i>.
   */
  public GetAllScenesReturnStruct(GetAllScenesReturnStruct other) {
    __isset_bitfield = other.__isset_bitfield;
    this.retval = other.retval;
    if (other.isSet_sceneIds()) {
      List<Byte> __this___sceneIds = new ArrayList<Byte>(other._sceneIds);
      this._sceneIds = __this___sceneIds;
    }
  }

  public GetAllScenesReturnStruct deepCopy() {
    return new GetAllScenesReturnStruct(this);
  }

  @Override
  public void clear() {
    setRetvalIsSet(false);
    this.retval = 0;
    this._sceneIds = null;
  }

  public byte getRetval() {
    return this.retval;
  }

  public GetAllScenesReturnStruct setRetval(byte retval) {
    this.retval = retval;
    setRetvalIsSet(true);
    return this;
  }

  public void unsetRetval() {
    __isset_bitfield = EncodingUtils.clearBit(__isset_bitfield, __RETVAL_ISSET_ID);
  }

  /** Returns true if field retval is set (has been assigned a value) and false otherwise */
  public boolean isSetRetval() {
    return EncodingUtils.testBit(__isset_bitfield, __RETVAL_ISSET_ID);
  }

  public void setRetvalIsSet(boolean value) {
    __isset_bitfield = EncodingUtils.setBit(__isset_bitfield, __RETVAL_ISSET_ID, value);
  }

  public int get_sceneIdsSize() {
    return (this._sceneIds == null) ? 0 : this._sceneIds.size();
  }

  public java.util.Iterator<Byte> get_sceneIdsIterator() {
    return (this._sceneIds == null) ? null : this._sceneIds.iterator();
  }

  public void addTo_sceneIds(byte elem) {
    if (this._sceneIds == null) {
      this._sceneIds = new ArrayList<Byte>();
    }
    this._sceneIds.add(elem);
  }

  public List<Byte> get_sceneIds() {
    return this._sceneIds;
  }

  public GetAllScenesReturnStruct set_sceneIds(List<Byte> _sceneIds) {
    this._sceneIds = _sceneIds;
    return this;
  }

  public void unset_sceneIds() {
    this._sceneIds = null;
  }

  /** Returns true if field _sceneIds is set (has been assigned a value) and false otherwise */
  public boolean isSet_sceneIds() {
    return this._sceneIds != null;
  }

  public void set_sceneIdsIsSet(boolean value) {
    if (!value) {
      this._sceneIds = null;
    }
  }

  public void setFieldValue(_Fields field, Object value) {
    switch (field) {
    case RETVAL:
      if (value == null) {
        unsetRetval();
      } else {
        setRetval((Byte)value);
      }
      break;

    case _SCENE_IDS:
      if (value == null) {
        unset_sceneIds();
      } else {
        set_sceneIds((List<Byte>)value);
      }
      break;

    }
  }

  public Object getFieldValue(_Fields field) {
    switch (field) {
    case RETVAL:
      return Byte.valueOf(getRetval());

    case _SCENE_IDS:
      return get_sceneIds();

    }
    throw new IllegalStateException();
  }

  /** Returns true if field corresponding to fieldID is set (has been assigned a value) and false otherwise */
  public boolean isSet(_Fields field) {
    if (field == null) {
      throw new IllegalArgumentException();
    }

    switch (field) {
    case RETVAL:
      return isSetRetval();
    case _SCENE_IDS:
      return isSet_sceneIds();
    }
    throw new IllegalStateException();
  }

  @Override
  public boolean equals(Object that) {
    if (that == null)
      return false;
    if (that instanceof GetAllScenesReturnStruct)
      return this.equals((GetAllScenesReturnStruct)that);
    return false;
  }

  public boolean equals(GetAllScenesReturnStruct that) {
    if (that == null)
      return false;

    boolean this_present_retval = true;
    boolean that_present_retval = true;
    if (this_present_retval || that_present_retval) {
      if (!(this_present_retval && that_present_retval))
        return false;
      if (this.retval != that.retval)
        return false;
    }

    boolean this_present__sceneIds = true && this.isSet_sceneIds();
    boolean that_present__sceneIds = true && that.isSet_sceneIds();
    if (this_present__sceneIds || that_present__sceneIds) {
      if (!(this_present__sceneIds && that_present__sceneIds))
        return false;
      if (!this._sceneIds.equals(that._sceneIds))
        return false;
    }

    return true;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  @Override
  public int compareTo(GetAllScenesReturnStruct other) {
    if (!getClass().equals(other.getClass())) {
      return getClass().getName().compareTo(other.getClass().getName());
    }

    int lastComparison = 0;

    lastComparison = Boolean.valueOf(isSetRetval()).compareTo(other.isSetRetval());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSetRetval()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this.retval, other.retval);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    lastComparison = Boolean.valueOf(isSet_sceneIds()).compareTo(other.isSet_sceneIds());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSet_sceneIds()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this._sceneIds, other._sceneIds);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    return 0;
  }

  public _Fields fieldForId(int fieldId) {
    return _Fields.findByThriftId(fieldId);
  }

  public void read(org.apache.thrift.protocol.TProtocol iprot) throws org.apache.thrift.TException {
    schemes.get(iprot.getScheme()).getScheme().read(iprot, this);
  }

  public void write(org.apache.thrift.protocol.TProtocol oprot) throws org.apache.thrift.TException {
    schemes.get(oprot.getScheme()).getScheme().write(oprot, this);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("GetAllScenesReturnStruct(");
    boolean first = true;

    sb.append("retval:");
    sb.append(this.retval);
    first = false;
    if (!first) sb.append(", ");
    sb.append("_sceneIds:");
    if (this._sceneIds == null) {
      sb.append("null");
    } else {
      sb.append(this._sceneIds);
    }
    first = false;
    sb.append(")");
    return sb.toString();
  }

  public void validate() throws org.apache.thrift.TException {
    // check for required fields
    // check for sub-struct validity
  }

  private void writeObject(java.io.ObjectOutputStream out) throws java.io.IOException {
    try {
      write(new org.apache.thrift.protocol.TCompactProtocol(new org.apache.thrift.transport.TIOStreamTransport(out)));
    } catch (org.apache.thrift.TException te) {
      throw new java.io.IOException(te);
    }
  }

  private void readObject(java.io.ObjectInputStream in) throws java.io.IOException, ClassNotFoundException {
    try {
      // it doesn't seem like you should have to do this, but java serialization is wacky, and doesn't call the default constructor.
      __isset_bitfield = 0;
      read(new org.apache.thrift.protocol.TCompactProtocol(new org.apache.thrift.transport.TIOStreamTransport(in)));
    } catch (org.apache.thrift.TException te) {
      throw new java.io.IOException(te);
    }
  }

  private static class GetAllScenesReturnStructStandardSchemeFactory implements SchemeFactory {
    public GetAllScenesReturnStructStandardScheme getScheme() {
      return new GetAllScenesReturnStructStandardScheme();
    }
  }

  private static class GetAllScenesReturnStructStandardScheme extends StandardScheme<GetAllScenesReturnStruct> {

    public void read(org.apache.thrift.protocol.TProtocol iprot, GetAllScenesReturnStruct struct) throws org.apache.thrift.TException {
      org.apache.thrift.protocol.TField schemeField;
      iprot.readStructBegin();
      while (true)
      {
        schemeField = iprot.readFieldBegin();
        if (schemeField.type == org.apache.thrift.protocol.TType.STOP) { 
          break;
        }
        switch (schemeField.id) {
          case 1: // RETVAL
            if (schemeField.type == org.apache.thrift.protocol.TType.BYTE) {
              struct.retval = iprot.readByte();
              struct.setRetvalIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          case 2: // _SCENE_IDS
            if (schemeField.type == org.apache.thrift.protocol.TType.LIST) {
              {
                org.apache.thrift.protocol.TList _list48 = iprot.readListBegin();
                struct._sceneIds = new ArrayList<Byte>(_list48.size);
                for (int _i49 = 0; _i49 < _list48.size; ++_i49)
                {
                  byte _elem50;
                  _elem50 = iprot.readByte();
                  struct._sceneIds.add(_elem50);
                }
                iprot.readListEnd();
              }
              struct.set_sceneIdsIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          default:
            org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
        }
        iprot.readFieldEnd();
      }
      iprot.readStructEnd();

      // check for required fields of primitive type, which can't be checked in the validate method
      struct.validate();
    }

    public void write(org.apache.thrift.protocol.TProtocol oprot, GetAllScenesReturnStruct struct) throws org.apache.thrift.TException {
      struct.validate();

      oprot.writeStructBegin(STRUCT_DESC);
      oprot.writeFieldBegin(RETVAL_FIELD_DESC);
      oprot.writeByte(struct.retval);
      oprot.writeFieldEnd();
      if (struct._sceneIds != null) {
        oprot.writeFieldBegin(_SCENE_IDS_FIELD_DESC);
        {
          oprot.writeListBegin(new org.apache.thrift.protocol.TList(org.apache.thrift.protocol.TType.BYTE, struct._sceneIds.size()));
          for (byte _iter51 : struct._sceneIds)
          {
            oprot.writeByte(_iter51);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      oprot.writeFieldStop();
      oprot.writeStructEnd();
    }

  }

  private static class GetAllScenesReturnStructTupleSchemeFactory implements SchemeFactory {
    public GetAllScenesReturnStructTupleScheme getScheme() {
      return new GetAllScenesReturnStructTupleScheme();
    }
  }

  private static class GetAllScenesReturnStructTupleScheme extends TupleScheme<GetAllScenesReturnStruct> {

    @Override
    public void write(org.apache.thrift.protocol.TProtocol prot, GetAllScenesReturnStruct struct) throws org.apache.thrift.TException {
      TTupleProtocol oprot = (TTupleProtocol) prot;
      BitSet optionals = new BitSet();
      if (struct.isSetRetval()) {
        optionals.set(0);
      }
      if (struct.isSet_sceneIds()) {
        optionals.set(1);
      }
      oprot.writeBitSet(optionals, 2);
      if (struct.isSetRetval()) {
        oprot.writeByte(struct.retval);
      }
      if (struct.isSet_sceneIds()) {
        {
          oprot.writeI32(struct._sceneIds.size());
          for (byte _iter52 : struct._sceneIds)
          {
            oprot.writeByte(_iter52);
          }
        }
      }
    }

    @Override
    public void read(org.apache.thrift.protocol.TProtocol prot, GetAllScenesReturnStruct struct) throws org.apache.thrift.TException {
      TTupleProtocol iprot = (TTupleProtocol) prot;
      BitSet incoming = iprot.readBitSet(2);
      if (incoming.get(0)) {
        struct.retval = iprot.readByte();
        struct.setRetvalIsSet(true);
      }
      if (incoming.get(1)) {
        {
          org.apache.thrift.protocol.TList _list53 = new org.apache.thrift.protocol.TList(org.apache.thrift.protocol.TType.BYTE, iprot.readI32());
          struct._sceneIds = new ArrayList<Byte>(_list53.size);
          for (int _i54 = 0; _i54 < _list53.size; ++_i54)
          {
            byte _elem55;
            _elem55 = iprot.readByte();
            struct._sceneIds.add(_elem55);
          }
        }
        struct.set_sceneIdsIsSet(true);
      }
    }
  }

}

